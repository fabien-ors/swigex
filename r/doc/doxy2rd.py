#!/usr/bin/env python3
from pathlib import Path
import argparse
import xml.etree.ElementTree as ET
import re

class Function:
    def __init__(
        self,
        name="",
        docType="",
        alias="",
        title="",
        description="",
        usage="",
        arguments=None,
        format="",
        source="",
        references="",
        keyword="",
        note=""
    ):
        self.name = name
        self.docType = docType
        self.alias = alias
        self.title = title
        self.description = description
        self.usage = usage
        self.arguments = arguments or []
        self.format = format
        self.source = source
        self.references = references
        self.keyword = keyword
        self.note = note

    def to_rd(self):
        lines = []
        if self.name:
            lines.append(f"\\name{{{self.name}}}")
            lines.append(f"\\alias{{{self.name}}}")
        if self.docType:
            lines.append(f"\\docType{{{self.docType}}}")
        if self.title:
            lines.append(f"\\title{{{self.title}}}")
        if self.description:
            lines.append("\\description{\n" + self.description + "\n}")
        if self.usage:
            lines.append("\\usage{\n" + self.usage + "\n}")
        if self.arguments:
            lines.append("\\arguments{")
            for arg in self.arguments:
                lines.append(f"  \\item{{{arg['name']}}}{{{arg.get('description','')}}}")
            lines.append("}")
        if self.format:
            lines.append("\\format{\n" + self.format + "\n}")
        if self.note:
            lines.append("\\note{\n" + self.note + "\n}")
        if self.source:
            lines.append("\\source{\n" + self.source + "\n}")
        if self.references:
            lines.append("\\references{\n" + self.references + "\n}")
        if self.keyword:
            lines.append(f"\\keyword{{{self.keyword}}}")
        return "\n".join(lines)

    def write(self, output_dir):
        output_dir = Path(output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)
        rd_file = output_dir / f"{self.name}.Rd"
        with open(rd_file, "w", encoding="utf-8") as f:
            f.write(self.to_rd())
        return rd_file

class Class:
    def __init__(
        self,
        name="",
        title="",
        description="",
        methods=None,
        fields=None,
        source="",
        references="",
        keyword="",
        note=""
    ):
        self.name = name
        self.title = title
        self.description = description
        self.methods = methods or []
        self.fields = fields or []
        self.source = source
        self.references = references
        self.keyword = keyword
        self.note = note

    def to_rd(self):
        lines = []
        if self.name:
            lines.append(f"\\name{{{self.name}}}")
            lines.append(f"\\alias{{{self.name}}}")
        if self.title:
            lines.append(f"\\title{{{self.title}}}")
        if self.description:
            lines.append("\\description{\n" + self.description + "\n}")
        if self.fields:
            lines.append("\\format{")
            lines.append("  \\describe{")
            for f in self.fields:
                lines.append(f"    \\item{{{f['name']}}}{{{f.get('description','')}}}")
            lines.append("  }")
            lines.append("}")
        if self.methods:
            lines.append("\\details{")
            lines.append("Methods:")
            lines.append("  \\itemize{")
            for m in self.methods:
                display_name = m.split('_', 1)[-1] if '_' in m else m
                lines.append(f"    \\item \\link[={m}]{{{display_name}}}")
            lines.append("  }")
            lines.append("}")
        if self.note:
            lines.append("\\note{\n" + self.note + "\n}")
        if self.source:
            lines.append("\\source{" + self.source + "}")
        if self.references:
            lines.append("\\references{" + self.references + "}")
        if self.keyword:
            lines.append(f"\\keyword{{{self.keyword}}}")
        return "\n".join(lines)

    def write(self, output_dir):
        output_dir = Path(output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)
        rd_file = output_dir / f"{self.name}.Rd"
        with open(rd_file, "w", encoding="utf-8") as f:
            f.write(self.to_rd())
        return rd_file

class DoxygenParser:
    def __init__(self, xml_directory):
        self.xml_directory = Path(xml_directory)

    def _text(self, node):
        if node is None: return ""
        parts = []
        def walk(elem):
            if elem.tag == "simplesect" and elem.attrib.get("kind") in ("remark", "note"):
                return ""

            if elem.tag == "ref":
                refid = elem.attrib.get("refid", "")
                text_content = elem.text or ""
                for child in elem:
                    text_content += walk(child)
                parts.append(f"\\link[={refid.replace("class", "")}]{{{text_content.strip()}}}")
                if elem.tail:
                    parts.append(elem.tail)
                return ""

            if elem.tag == "formula":
                form_text = (elem.text or "").strip()
                if form_text.startswith("\\[") and form_text.endswith("\\]"):
                    eq = form_text[2:-2].strip()
                    parts.append(f"\n\\deqn{{{eq}}}{{{eq}}}\n")
                elif form_text.startswith("$") and form_text.endswith("$"):
                    eq = form_text[1:-1].strip()
                    parts.append(f"\\eqn{{{eq}}}{{{eq}}}")
                else:
                    parts.append(f"\\eqn{{{form_text}}}{{{form_text}}}")
                if elem.tail:
                    parts.append(elem.tail)
                return ""

            if elem.tag in ("para", "simplesect"):
                parts.append("\n\n")

            if elem.text: 
                parts.append(elem.text)
            for child in elem:
                walk(child)
                if child.tail: 
                    parts.append(child.tail)
        walk(node)
        
        full_text = "".join(parts)
        full_text = re.sub(r'\n{3,}', '\n\n', full_text)
        return full_text.strip()

    def _extract_remarks(self, node):
        if node is None: return ""
        remarks = []
        for simplesect in node.findall(".//simplesect"):
            if simplesect.attrib.get("kind") in ("remark", "note"):
                parts = []
                def walk_remark(elem):
                    if elem.text: parts.append(elem.text)
                    for child in elem:
                        walk_remark(child)
                        if child.tail: parts.append(child.tail)
                walk_remark(simplesect)
                remarks.append("".join(parts).strip())
        return "\n\n".join(remarks).strip()

    def _format_links(self, text):
        pattern = r'(?:\\|@)link\s+(\S+)\s+(.*?)\s*(?:\\|@)endlink'
        return re.sub(pattern, r'\\link[=\1]{\2}', text)

    def _get_arguments(self, memberdef):
        arguments = []
        for param in memberdef.findall("param"):
            pname = param.findtext("declname", "")
            arguments.append({"name": pname, "description": ""})
        detailed = memberdef.find("detaileddescription")
        if detailed is not None:
            for plist in detailed.findall(".//parameterlist"):
                if plist.attrib.get("kind") != "param": continue
                for item in plist.findall("parameteritem"):
                    names = [self._text(x) for x in item.findall(".//parametername")]
                    desc = self._text(item.find("parameterdescription"))
                    desc = self._format_links(desc)
                    for arg in arguments:
                        if arg["name"] in names: arg["description"] = desc
        return arguments

    def parse(self):
        functions = []
        classes = []
        for xml_file in self.xml_directory.glob("*.xml"):
            try:
                tree = ET.parse(xml_file)
                root = tree.getroot()
            except Exception: continue
            
            for compounddef in root.findall(".//compounddef"):
                kind = compounddef.attrib.get("kind", "")
                if kind not in ("class", "struct"): continue
                
                c_name = compounddef.findtext("compoundname", "")
                brief_node = compounddef.find("briefdescription")
                detailed_node = compounddef.find("detaileddescription")
                
                brief = self._text(brief_node)
                detailed = self._text(detailed_node)
                desc = "\n\n".join(x for x in [brief, detailed] if x)
                desc = self._format_links(desc)
                
                c_remark = "\n\n".join(x for x in [self._extract_remarks(brief_node), self._extract_remarks(detailed_node)] if x)
                
                methods = []
                fields = []
                for section in compounddef.findall("sectiondef"):
                    for member in section.findall("memberdef"):
                        if member.attrib.get("prot") in ("private", "protected"): continue
                        m_name = member.findtext("name", "")
                        m_kind = member.attrib.get("kind", "")
                        if m_kind == "function":
                            f_name = f"{c_name}_{m_name}"
                            methods.append(f_name)
                            
                            f_detailed_node = member.find("detaileddescription")
                            f_desc = self._text(f_detailed_node)
                            f_desc = self._format_links(f_desc)
                            f_remark = self._extract_remarks(f_detailed_node)
                            
                            functions.append(Function(
                                name=f_name,
                                title=m_name,
                                description=f_desc,
                                usage=f"{m_name}{member.findtext('argsstring', '')}",
                                arguments=self._get_arguments(member),
                                note=f_remark
                            ))
                        elif m_kind in ("variable", "property"):
                            f_field_node = member.find("briefdescription")
                            f_field_desc = self._text(f_field_node)
                            f_field_desc = self._format_links(f_field_desc)
                            fields.append({"name": m_name, "description": f_field_desc})
                
                classes.append(Class(name=c_name, title=c_name, description=desc, methods=methods, fields=fields, note=c_remark))
        return functions, classes

if __name__ == "__main__":
    parser_args = argparse.ArgumentParser()
    parser_args.add_argument("INPUT_DIR")
    parser_args.add_argument("OUTPUT_DIR")
    args = parser_args.parse_args()
    
    parser = DoxygenParser(args.INPUT_DIR)
    funcs, classes = parser.parse()
    
    for f in funcs: f.write(args.OUTPUT_DIR)
    for c in classes: c.write(args.OUTPUT_DIR)