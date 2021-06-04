-- Cleaning the data in SQL queries
select 
  * 
from 
  Housing..Housing_Data 
  
  --Standardize Date Format
select 
  SaleDate, 
  convert(Date, SaleDate) as Date 
from 
  Housing..Housing_Data 
Alter Table 
  Housing..Housing_Data 
add 
  SaleDateConverted Date;
Update 
  Housing..Housing_Data 
Set 
  SaleDateConverted = convert(Date, SaleDate) --Populate Property Address Data
select 
  PropertyAddress 
from 
  Housing..Housing_Data 
where 
  PropertyAddress is null 
  
  --now we will populate same address having same Parcel_ID

select 
  a.ParcelID, 
  a.PropertyAddress, 
  b.ParcelID, 
  b.PropertyAddress, 
  ISNULL(
    a.PropertyAddress, b.PropertyAddress
  ) 
from 
  Housing..Housing_Data a 
  join Housing..Housing_Data b on a.ParcelID = b.ParcelID 
  and a.[UniqueID ] <> b.[UniqueID ] 
where 
  a.PropertyAddress is null 
update 
  a 
set 
  PropertyAddress = ISNULL(
    a.PropertyAddress, b.PropertyAddress
  ) 
from 
  Housing..Housing_Data a 
  join Housing..Housing_Data b on a.ParcelID = b.ParcelID 
  and a.[UniqueID ] <> b.[UniqueID ] 
where 
  a.PropertyAddress is null
  
  --Breaking out address into into individual columns (Address, city, state)

Select 
  PropertyAddress 
from 
  Housing..Housing_Data 
Select 
  SUBSTRING(
    PropertyAddress, 
    1, 
    charindex(',', PropertyAddress)-1
  ) as Address, 
  SUBSTRING(
    PropertyAddress, 
    charindex(',', PropertyAddress)+ 1, 
    len(PropertyAddress)
  ) as City 
from 
  Housing..Housing_Data 
Alter Table 
  Housing..Housing_Data 
add 
  city char(20) 
Alter Table 
  Housing..Housing_Data 
add 
  PropertyLocation char(40) 
Update 
  Housing..Housing_Data 
Set 
  City = SUBSTRING(
    PropertyAddress, 
    charindex(',', PropertyAddress)+ 1, 
    len(PropertyAddress)
  ) 
Update 
  Housing..Housing_Data 
Set 
  PropertyLocation = SUBSTRING(
    PropertyAddress, 
    1, 
    charindex(',', PropertyAddress)-1
  ) 
select 
  PARSENAME(
    REPLACE(OwnerAddress, ',', '.'), 
    1
  ), 
  PARSENAME(
    REPLACE(OwnerAddress, ',', '.'), 
    2
  ), 
  PARSENAME(
    REPLACE(OwnerAddress, ',', '.'), 
    3
  ) 
from 
  Housing..Housing_Data 
Alter Table 
  Housing..Housing_Data 
add 
  OwnerSplitAddress char(40) 
Alter Table 
  Housing..Housing_Data 
add 
  OwnerSplitCity char(20) 
Alter Table 
  Housing..Housing_Data 
add 
  OwnerSplitState char(20) 
Update 
  Housing..Housing_Data 
Set 
  OwnerSplitAddress = PARSENAME(
    REPLACE(OwnerAddress, ',', '.'), 
    3
  ) 
Update 
  Housing..Housing_Data 
Set 
  OwnerSplitCity = PARSENAME(
    REPLACE(OwnerAddress, ',', '.'), 
    2
  ) 
Update 
  Housing..Housing_Data 
Set 
  OwnerSplitState = PARSENAME(
    REPLACE(OwnerAddress, ',', '.'), 1) 
  --Change Y or N to the Yes or No in "sold as vacant" field
select 
  distinct(SoldAsVacant) 
from 
  Housing..Housing_Data 
select 
  SoldAsVacant, 
  Case when SoldAsVacant = 'Y' Then 'Yes' when SoldAsVacant = 'N' Then 'No' else SoldAsVacant END 
from 
  Housing..Housing_Data 
update 
  Housing..Housing_Data 
Set 
  SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes' when SoldAsVacant = 'N' Then 'No' else SoldAsVacant END --Remmove Duplicates
  with RowNumCTE as(
    select 
      *, 
      ROW_NUMBER() over(
        Partition by ParcelID, 
        PropertyAddress, 
        SalePrice, 
        SaleDate, 
        LegalReference 
        order by 
          UniqueID
      ) row_num 
    from 
      Housing..Housing_Data
  ) 
Delete from 
  RowNumCTE 
where 
  row_num > 1 
  
  -- Delete unused Columns

select 
  * 
from 
  Housing..Housing_Data 
Alter Table 
  Housing..Housing_Data 
Drop 
  Column PropertyAddress, 
  OwnerAddress, 
  TaxDistrict, 
  saleDate
