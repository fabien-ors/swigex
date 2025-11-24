/******************************************************************************/
/*                                                                            */
/*                            gstlearn C++ Library                            */
/*                                                                            */
/* Copyright (c) (2023) MINES Paris / ARMINES                                 */
/* Authors: gstlearn Team                                                     */
/* Website: https://gstlearn.org                                              */
/* License: BSD 3-clause                                                      */
/*                                                                            */
/******************************************************************************/
#pragma once

#include "swigex_export.hpp"
#include "swigex_define.hpp"
#include "VectorNumT.hpp"
#include "VectorT.hpp"
#include "OptCst.hpp"

#include <iomanip>

#define CASE_DOUBLE 0
#define CASE_REAL   1
#define CASE_INT    2
#define CASE_COL    3
#define CASE_ROW    4

// Functions for returning parameters from OptCst environment
inline Id _getColumnRank()
{
  return static_cast<Id>(OptCst::query(OptCst::E_NTRANK));
}
inline Id _getColumnName()
{
  return static_cast<Id>(OptCst::query(OptCst::E_NTNAME));
}
inline Id _getColumnSize(Id localSize = 0, Id nColumns = 1)
{
  if (localSize > 0) return localSize;
  Id size = 1 + static_cast<Id>(OptCst::query(OptCst::E_NTCAR));
  if (nColumns == 1) return size;
  return size * nColumns; // account for spaces between columns
}
inline Id _getMaxNCols()
{
  return static_cast<Id>(OptCst::query(OptCst::E_NTCOL));
}
inline Id _getMaxNRows()
{
  return static_cast<Id>(OptCst::query(OptCst::E_NTROW));
}
inline Id _getNBatch()
{
  return static_cast<Id>(OptCst::query(OptCst::E_NTBATCH));
}
inline Id _getDecimalNumber()
{
  return static_cast<Id>(OptCst::query(OptCst::E_NTDEC));
}
inline double _getThresh()
{
  Id ndec       = static_cast<Id>(OptCst::query(OptCst::E_NTDEC));
  double thresh = (0.5 * pow(10, -ndec));
  return thresh;
}

inline Id getMaxStringSize(const VectorString& list)
{
  Id size = 0;
  if (list.empty()) return size;
  for (Id i = 0; i < static_cast<Id>(list.size()); i++)
  {
    Id local = static_cast<Id>(list[i].length());
    if (local > size) size = local;
  }
  return size;
}

// Functions for encoding a single value
inline std::stringstream _formatOneColumn(Id justification    = 1,
                                          Id localSize        = 0,
                                          Id nColumns         = 1,
                                          bool flagScientific = false)
{
  std::stringstream sstr;
  auto size = static_cast<I32>(_getColumnSize(localSize, nColumns));
  auto prec = static_cast<I32>(_getDecimalNumber());
  // Define the format fixed or scientific
  if (flagScientific)
    sstr << std::scientific;
  else
    sstr << std::fixed;
  // Define the size and number of decimals
  sstr << std::setw(size) << std::setprecision(prec);
  // Define justification
  if (justification < 0)
    sstr << std::left;
  else
    sstr << std::right;
  return sstr;
}

inline String _formatOneString(const String& string, Id justification, Id localSize, Id nColumns)
{
  std::stringstream sstr = _formatOneColumn(justification, localSize, nColumns);
  Id size                = static_cast<Id>(string.size());
  Id truncSize           = _getColumnSize(localSize, nColumns);
  if (size > truncSize)
  {
    // String must be truncated

    String strloc = string;
    strloc.erase(0, size - truncSize);
    strloc.replace(0, 2, " *");
    sstr << strloc;
  }
  else
  {
    sstr << string;
  }
  return sstr.str();
}

inline String _formatOneDouble(double value,
                               Id justification,
                               Id localSize,
                               bool roundZero,
                               Id nColumns,
                               bool flagScientific)
{
  std::stringstream sstr = _formatOneColumn(justification, localSize, nColumns, flagScientific);
  if (isNA<double>(value))
  {
    sstr << "N/A";
  }
  else
  {
    // Arrondir les très petites valeurs à zéro si demandé
    if (roundZero)
    {
      // Prevent -0.00 : https://stackoverflow.com/a/12536500/3952924
      value = (std::abs(value) < _getThresh()) ? 0. : value;
    }

    if (flagScientific)
    {
      // 1) Si valeur proche d'un entier → affichage sans décimales
      double rounded = std::round(value);
      if (std::abs(value - rounded) < 1e-12) // tolérance pour éviter 0.9999999
      {
        sstr << std::defaultfloat << static_cast<long long>(rounded);
        return sstr.str();
      }
    }

    sstr << value;
  }
  return sstr.str();
}

String _formatOneId(Id value, Id justification, Id localSize, Id nColumns)
{
  std::stringstream sstr = _formatOneColumn(justification, localSize, nColumns);
  if (isNA<Id>(value))
    sstr << "N/A";
  else
    sstr << value;

  return sstr.str();
}

inline String toStr(double v,
                    Id justification    = 1,
                    Id localSize        = 0,
                    bool roundZero      = true,
                    Id nColumns         = 1,
                    bool flagScientific = false)
{
  std::stringstream sstr;
  sstr << _formatOneDouble(v, justification, localSize, roundZero, nColumns, flagScientific);
  
  return sstr.str();
}
inline String toStr(Id v,
                    Id justification = 1,
                    Id localSize     = 0,
                    bool roundZero   = true,
                    Id nColumns      = 1)
{
  DECLARE_UNUSED_(roundZero);
  std::stringstream sstr;
  sstr << _formatOneId(v, justification, localSize, nColumns);
  return sstr.str();
}
inline String toStr(const String& v,
                    Id justification = 1,
                    Id localSize     = 0,
                    bool roundZero   = true,
                    Id nColumns      = 1)
{
  DECLARE_UNUSED_(roundZero);
  std::stringstream sstr;
  sstr << _formatOneString(v, justification, localSize, nColumns);
  return sstr.str();
}

// Functions for beautifying a suite of values
inline String _toStrRowColumn(Id icase, Id value, bool flagAdd)
{
  std::stringstream sstr;
  I32 rank  = static_cast<I32>(_getColumnRank());
  I32 width = static_cast<I32>(_getColumnSize() - _getColumnRank() - 1);
  sstr << std::setw(width) << std::right;
  if (icase == CASE_ROW)
  {
    if (!flagAdd)
      sstr << "[" << std::setw(rank) << value << ",]";
    else
      sstr << "[" << std::setw(rank) << value << "+]";
  }
  else
  {
    if (!flagAdd)
      sstr << "[," << std::setw(rank) << value << "]";
    else
      sstr << "[ " << std::setw(rank) << value << "]";
  }
  return sstr.str();
}

inline String _toStrRowHeader(const VectorString& rownames, Id iy, Id rowSize)
{
  std::stringstream sstr;
  if (!rownames.empty())
    sstr << toStr(rownames[iy], -1, rowSize);
  else
    sstr << _toStrRowColumn(CASE_ROW, iy, false);
  return sstr.str();
}

inline String _toStrColumnHeaders(const VectorString& colnames, Id colfrom, Id colto, Id colSize = 0)
{
  std::stringstream sstr;
  if (!colnames.empty())
  {
    // By Names
    sstr << toStr(" ", 1) << " ";
    for (Id ix = colfrom; ix < colto; ix++)
      sstr << toStr(colnames[ix], 1, colSize);
    sstr << std::endl;
  }
  else
  {
    // By Numbers
    sstr << toStr(" ", 1) << " ";
    for (Id ix = colfrom; ix < colto; ix++)
      sstr << _toStrRowColumn(CASE_COL, ix, false);
    sstr << std::endl;
  }
  return sstr.str();
}

#ifndef SWIG
template<typename T>
String toStrMatrix(const String& title,
                   const VectorString& colnames,
                   const VectorString& rownames,
                   bool bycol,
                   Id nrows,
                   Id ncols,
                   const VectorNumT<T>& tab,
                   bool flagOverride = false,
                   bool flagSkipZero = false)
{
  std::stringstream sstr;
  if (tab.empty() || ncols <= 0 || nrows <= 0) return sstr.str();

  /* Initializations */

  Id ncutil = ncols;
  Id nrutil = nrows;
  if (_getMaxNCols() > 0 && ncutil > _getMaxNCols() && !flagOverride) ncutil = _getMaxNCols();
  if (_getMaxNRows() > 0 && nrutil > _getMaxNRows() && !flagOverride) nrutil = _getMaxNRows();
  Id npass       = static_cast<Id>(ceil(static_cast<double>(ncutil) / static_cast<double>(_getNBatch())));
  bool multi_row = nrutil > 1 || npass > 1;

  Id colSize = 0;
  if (colnames.empty())
    colSize = _getColumnSize();
  else
    colSize = MAX(MIN(_getColumnName(), getMaxStringSize(colnames) + 1), _getColumnSize());
  Id rowSize = 0;
  if (rownames.empty())
    rowSize = _getColumnSize();
  else
    rowSize = MAX(getMaxStringSize(rownames) + 1, _getColumnSize());

  /* Print the title (optional) */

  if (!title.empty())
  {
    sstr << title;
    if (multi_row) sstr << std::endl;
  }

  // Loop on the batches

  for (Id ipass = 0; ipass < npass; ipass++)
  {
    Id jdeb = ipass * _getNBatch();
    Id jfin = MIN(jdeb + _getNBatch(), ncutil);

    /* Print the names of the columns and the column numbers */

    if (multi_row) sstr << _toStrColumnHeaders(colnames, jdeb, jfin, colSize);

    /* Loop on the rows */

    for (Id iy = 0; iy < nrutil; iy++)
    {
      if (multi_row) sstr << _toStrRowHeader(rownames, iy, rowSize);

      /* Loop on the columns */
      for (Id ix = jdeb; ix < jfin; ix++)
      {
        Id iad = (bycol) ? iy + nrows * ix : ix + ncols * iy;
        if (flagSkipZero && ABS(tab[iad]) < EPSILON20)
          sstr << toStr(".", 1, colSize);
        else
          sstr << toStr(tab[iad], 1, colSize);
      }
      sstr << std::endl;
    }
  }
  return sstr.str();
}

#endif // SWIG