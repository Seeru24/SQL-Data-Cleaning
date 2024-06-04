SELECT * 
FROM HousingData

--Standardize SaleDate

SELECT SaleDate, CAST(SaleDate AS date) AS SALEDATE --The sale date was firstly in datetime format now it is only in date format
FROM HousingData

--UPDATE HousingData 
--SET SaleDate = CAST(SaleDate AS date)

--SELECT SaleDate 
--FROM HousingData

ALTER TABLE HousingData
ADD SaleDateConverted DATE

UPDATE HousingData
SET SaleDateConverted = CAST(SaleDate AS date)

SELECT SaleDateConverted
FROM HousingData

--Populate Property Address Data

SELECT PropertyAddress
FROM HousingData
WHERE PropertyAddress IS NULL

SELECT *
FROM HousingData
WHERE PropertyAddress IS NULL

SELECT *
FROM HousingData
ORDER BY 2 --Looked at the same parcel ID 

--Now we will do that if one parcel ID has an address and the other does'nt populate it with the 1st parcel ID address

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(b.PropertyAddress,a.PropertyAddress) AS UPDATEDADDRESS
FROM HousingData a
JOIN HousingData b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE b.PropertyAddress IS NULL

UPDATE b --We will use the alias because otherwise it will give us an error of ambuiguity
SET PropertyAddress = ISNULL(b.PropertyAddress,a.PropertyAddress)
FROM HousingData a
JOIN HousingData b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE b.PropertyAddress IS NULL

--Breaking out address into individual columns (Address, City, State)

SELECT PropertyAddress
FROM HousingData

SELECT  --string        --start --lenght of string we want here we want until ',' so we used charindex
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address  --we wrote -1 to eliminate the comma same for +1
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS City   --syntax of charindex = CHARINDEX(SUBSTRING TO BE SEARCHED, THE STRING IN WHICH WE SHOULD DO SEARCH)
FROM HousingData

ALTER TABLE HousingData
ADD PropertySplitAddress varchar(255)

ALTER TABLE HousingData
ADD PropertySplitCity varchar(255)

UPDATE HousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

UPDATE HousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

--Doing the same with Owner Address in a simpler way

SELECT OwnerAddress
FROM HousingData

SELECT 
PARSENAME(OwnerAddress,1)  --this will not give any result because the parsename uses period to seperate entities but in owner address it is seperated by comas so we will first replace like in next query
FROM HousingData
WHERE OwnerAddress IS NOT NULL

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3), --It operates things backwards
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM HousingData
WHERE OwnerAddress IS NOT NULL

ALTER TABLE HousingData
ADD OwnerSplitAddress varchar(255)

ALTER TABLE HousingData
ADD OwnerSplitCity varchar(255)

ALTER TABLE HousingData
ADD OwnerSplitState varchar(255)

UPDATE HousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1) --We can update multiple columns in this way without writing whole syntax again

-- Change Y and N to Yes and No in 'Sold as Vacant' Feild

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM HousingData
GROUP BY SoldAsVacant
ORDER BY 2

--Using Case Statement

SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
FROM HousingData

UPDATE HousingData
SET SoldAsVacant = 
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END

--Delete Unused Columns (Bad Practice Dont do this to your raw data)

SELECT * 
FROM HousingData

ALTER TABLE HousingData
DROP COLUMN SaleDate, PropertyAddress, OwnerAddress, TaxDistrict




