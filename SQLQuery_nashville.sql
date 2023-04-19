/* Cleaning the data using SQL queries*/

Select *
from PortfolioProject..NashvilleHousing

--Standardize the date format

select SaleDate, CONVERT(date, SaleDate)
from PortfolioProject..NashvilleHousing

Alter Table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted=CONVERT(date, SaleDate)

---for checking
select SaleDateConverted, CONVERT(date, SaleDate)
from PortfolioProject..NashvilleHousing

--Populate Property Address data


select *
from PortfolioProject..NashvilleHousing
--where PropertyAddress is Null
order by ParcelID



select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID=b.ParcelID 
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is Null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID=b.ParcelID 
	and a.[UniqueID ]<>b.[UniqueID ]
	where a.PropertyAddress is Null

--to check the table

select * 
from PortfolioProject..NashvilleHousing

----Breaking out Address into Individual columns (address , city,state)

select PropertyAddress
from PortfolioProject..NashvilleHousing

select
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress))as Address
from PortfolioProject..NashvilleHousing

--For Altering the table-Split address in to 3 columns

Alter Table NashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
set PropertySplitAddress=SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

Alter Table NashvilleHousing
add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
set PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress))

--droping the column
Alter table PortfolioProject..NashvilleHousing
drop column ProperySplitCity 

---to check
Select * 
from PortfolioProject..NashvilleHousing


---Split the OwnerAddress into 3 columns

Select OwnerAddress
from PortfolioProject..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing


--Alter and update the table

Alter Table NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
set OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

Alter Table NashvilleHousing
add OwnerplitCity Nvarchar(255);

Update NashvilleHousing
set OwnerplitCity=PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

Alter Table NashvilleHousing
add OwnerplitState Nvarchar(255);

Update NashvilleHousing
set OwnerplitState=PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select
* from PortfolioProject..NashvilleHousing

--Change Y and N to Yes and No in "sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--Remove duplicates


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject..NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1 --if count of rownumber is greater than 1
Order by PropertyAddress

select *
from PortfolioProject..NashvilleHousing

-- delete duplicate columns

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject..NashvilleHousing
)
delete 
From RowNumCTE
Where row_num > 1 --if count of rownumber is greater than 1


--Delete unused columns

select *
from PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate




