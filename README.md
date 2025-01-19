# RFM SEGMENTATION | 2020-2022

## Context 
This project presents RFM segementation for an e-commerce business for the period 2020-2022. The aim is to use data-driven insights to identify valuable customers, optimize marketing efforts, and design targeted campaigns to enhance revenue and customer engagement on the platform. 

### Insights 
- Less Repeat Purchases: Over 70% of customers are one time buyers, indicating a lack of customer retention or poor user experinece with the products.
- Average Spending is very low: The average customer spends only £46.48, prseneting the need to encourage higher spending.
- Very Small portion of High-Value Customers: Only 0.08% of customers are categorized as "Champions" (high-value customers).
- Negligible Loyal Customers: A mere 0.02% of customers are considered loyal, suggesting weak long-term engagement.

### Steps followed 

- Step 1 : Gathered users data from the company's database.
- Step 2 : Selected the required columns and records need for RFM segmentation.
- Step 3 : Performed data cleaning and preprocessing such as checking if each column has correct data type. And also remove the dublicates
- Step 4 :
  #### Recency Calculation
 - Define Recency as the difference between the last date of the dataset and latest purchase date. 
 - Define the buckets for the recency based on the distribution of data. For this, average, minimum, Maximum,  25th percentile, 50th percentile and median have been calculated to know about the distribution of data. 
- [SQL CODE for recency and statsical analysis](https://raw.githubusercontent.com/anchalds246/RFM-Segmentation/refs/heads/main/recency_Stats.sql?token=GHSAT0AAAAAAC5GMA43RE5Z6XOVUMDPNG7CZ4NEMQA)
- Table showing the distribution of data:
  <div align="center">
| **Metric**               | **Value** |
|--------------------------|-----------|
| Total Customers          | 219,550   |
| Minimum Recency          | 0         |
| Maximum Recency          | 820       |
| Average Recency          | 338.02    |
| 25th Percentile (P25)    | 102.0     |
| Median Recency           | 292.0     |
| 75th Percentile (P75)    | 578.0     |

</div>


- Based on this distribution, the renency buckets have been defined as below:
  
| **Bucket**  | **Range**   | **Description**               | **Recency Score**|
|-------------|-------------|-------------------------------|------------------|
| Bucket 1    | 0–100       | Very recent Customer          |5                 |
| Bucket 2    | 101–300     | Recent   customer             |4| 
| Bucket 3    | 301–500     | Moderate recency              |3|
| Bucket 4    | 501–700     | Not Recent customer           |2|
| Bucket 5    | >700        | Lost customer                 |1|

#### Frequency Calculation 
- Frequency is define on the basis of transaction count for each user.
- Similar to recency, the statstical analysis is done for frequnecy also to define the buckets
- [SQL Code for frequency statistical analysis](https://raw.githubusercontent.com/anchalds246/RFM-Segmentation/refs/heads/main/Frequency_Stats.sql?token=GHSAT0AAAAAAC5GMA43KW2THLLLD23FXGE4Z4NENZQ)
- Table showing the distribution of data:

| Metric               | Total Customers | Min Transactions | Max Transactions | Avg Transactions | P25 Transactions | Median Transactions | P75 Transactions |
|----------------------|-----------------|------------------|------------------|------------------|------------------|----------------------|------------------|
| **Value**           | 219,550         | 1                | 402              | 1.65             | 1.0              | 1.0                 | 2.0              |

- Based on this distribution, the renency buckets have been defined as below:
  
| **Bucket**  | **Range**   | **Description**               | **Frequency Score**|
|-------------|-------------|-------------------------------|--------------------|
| Bucket 1    | 1      | Very Low Frequency          |1|
| Bucket 2    | 2-5     |Low Frequency            |2|
| Bucket 3    | 6-20     | Medium Frequency              |3|
| Bucket 4    | 21-100     | High Frequency           |4|
| Bucket 5    | >100    | Very High Frequency              |5|

#### Monetary Value (MV)
- MV is defined as the revenue contributed by each customer
- Statstical analysis for MV has also been done.
- [SQL code for MV statistical analysis](https://raw.githubusercontent.com/anchalds246/RFM-Segmentation/refs/heads/main/MV_Stats.sql?token=GHSAT0AAAAAAC5GMA43544OTLRYVX74GA3CZ4NEJ7A)
- Table showing the distribution of data:

  | Metric               | Total Customers | Min Revenue | Max Revenue | Avg Revenue | P25 Revenue | Median Revenue | P75 Revenue |
  |----------------------|-----------------|-------------|-------------|-------------|-------------|----------------|-------------|
  | **Value**            | 219,550         | 3.49        | 11,159.53   | 46.48       | 15.0        | 25.99          | 50.0        |

- Based on this distribution, the renency buckets have been defined as below:


| Bucket Number | Revenue Range         | Description        |**MV Score**|
|---------------|-----------------------|--------------------|--------------|
| Bucket 1      | £3.49–£15.00          | Very Low revenue        |1|
| Bucket 2      | £15.01–£50.00         |Low revenue  |2|
| Bucket 3      | £50.01–£200.00        | Moderate revenue       |3|
| Bucket 4      | £200.01–£1,000.00     | high revenue  |4|
| Bucket 5      | £1,000.01–£11,159.53  | Very high revenue   |5|

#### Segment Definition 

| Segment             | Definition                                                                | RFM Score                                                                                                      |
|---------------------|--------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Champions**        | Recent and frequent buyers, and spend the most!                          | '555', '554', '544', '545', '454', '455', '445'                                                                                                                         |
| **Loyal Cusromers**            | Spend good money with us often.               | '543', '444', '435', '355', '354', '345', '344', '335'                                                                                                                   |
| **Loyality Builders** | Recent customers, but spent a decent amount and made more than one purchases   | '553', '551', '552', '541', '542', '533', '532', '451', '452', '441', '442', '431', '453', '433', '432', '423', '353', '352', '351', '342', '341', '333', '323'       |
| **Fresh Faces**    | Recent, but not frequent customer                                    | '512', '511', '422', '421', '412', '411', '313'                                                                                                                         |
| **Rising Starts**        | Recent customer, but didn't spend much yet                                | '525', '524', '523', '522', '521', '515', '514', '513', '425', '424', '413', '414', '415', '315', '314', '313'                                                         |
| **Need Attention**   | Above average RFM values. May not have bought very recently though. | '535', '534', '443', '434', '343', '334', '325', '324'                                                                                                                   |
| **About To Sleep**   | Below average RFM values. Will lose them if not re-engaged. | '331', '321', '312', '221', '213', '231', '241', '251'                                        |
| **High Risk Segment**          | Spent big money and purchased often. But a long time ago. Need to bring them back! | '255', '254', '245', '244', '243', '252', '242', '235', '234', '225', '224', '153', '152', '145', '143', '142', '135', '134', '133', '125', '124'                   |
| **Cannot Lose Them** | spent highest, and often. But haven’t interacted for a long time | '155', '144', '214', '215', '115', '114', '113'                                                            |
| **Silent Shoppers**  | Last purchase was a long time back, low spenders, and not much orders | '332', '322', '231', '241', '251', '233', '223', '222', '132', '123', '122', '212', '211'                 |
| **Lapsed**   | Lowest RFM values.                         | '111', '112', '121', '131', '141', '151'                                                                                |
#### RFM Segmentation Code
Combined the code for recency, frequency and monetary value and exceuted a SQL code for RFM. 
[RFM Segmentation Code](https://raw.githubusercontent.com/anchalds246/RFM-Segmentation/refs/heads/main/new_rfm_1.sql?token=GHSAT0AAAAAAC5GMA43QZTVBJZEEDSAGH7CZ4NEOXQ)


#### Dashboard Desining 
- Load the data from the Google Bigquery to power BI (Saves time in loading all millions of rows direcly from the dataset)
- Start Visualising the data
- As maximum of the calculation has been done using the SQL, so there was no need of DAX calculation
- The dashbaord has been uploaded in this repository.
- The Dashboard was created and published to the POWER BI service :
  ![Image](https://github.com/user-attachments/assets/4aba05c2-8a1e-4f23-a1f8-d5f19e126fbe)
