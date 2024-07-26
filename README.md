# Welcome to my Bitso Challenge!

Hello!
Here is the documentation for my Bitso Challenge 2.
This challenge consists on the design for an Analytical data model, capable of answering questions provided.

Created by: **Max Mondragon**.


## Data Modeling

I used a data modeling approach with snowflake schema, it consists on a set of Fact tables (that contain transactional data) with their required Dimension tables (that provide context to this data).

For the dimensions, at the very least the primary key should be indexed.
For the Fact tables, an interval partitioning should be used, most commonly on a daily basis. Indexes may be added accordingly to common needs.

This design has the advantage of simplifying queries over different entities, for example instead of consulting Deposits and Withdrawals as two entities, they can be used as one, facilitating tasks like Dashboard creations, analytics and data science.
As usual, this model has a performance advantage over, for example, de-normalized tables. Mostly due to range or unique search on integer columns Vs possible full data scans on text data.

One possible downside may be easiness of use. A denormalized table can be understood just by reading its columns, while a snowflake (and star) schema requires the join operation with relevant dimensions to understand the data.
Denormalization approach may be better suited for DataLakes and NoSQL systems which advantage resides in massive parallelization.


## Installation

I used a traditional Database Engine for the example, using a Docker image for MySQL available [Here](https://hub.docker.com/r/mysql/mysql-server/).
Using "docker-compose up -d" and accessing MySQL through a client like SQL Workbech.

## Processing

Data should be loaded into stage tables first, some cleansing may happen here (like removing duplicated records based on transaction id and so on).
For the first data load, I attached the scripts required from stage -> analytics data model.

For a normal automatic execution, dimensions should use a Merge technique, as slowly changing dimensions.
Type 2 dimensions can be considered for tables where we need to keep the historical data. Which doesn't seem to be the case here.

Fact tables should have the working partition truncated and loaded each execution. For orchestration, they should update after all the dependencies are ready (previous refresh on dimensions and stage data).


## Results

All tables have been exported to CSV, with the exception of Date and Time dimension. These ones serve more as a utility and have not really been required in the analysis.

