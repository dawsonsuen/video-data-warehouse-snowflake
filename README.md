# Video Data Warehouse Design

The purpose of this repository is to demonstrate how to construct a START schema data warehouse which used to track VideoStarts over time. The SQL queries use SnowSQL syntax to populate the Data Warehouse Dimension and Fact tables.

## Process Design

1.  Use SnowSQL CLI to load raw VideoStarts file into SRC_VIDEOSTART

    a. Copy File to Stage
  
    ```
    CREATE STAGE "MY_CSV_STAGE";
    put file://~/video_data.csv @my_csv_stage1 auto_compress=true;    
    ```
    
    b. Create File Format
    
    ```
    CREATE OR Replace FILE FORMAT video_1 TYPE 
                                     = 'CSV'
                                     COMPRESSION = 'GZIP'
                                     FIELD_DELIMITER = ','
                                     RECORD_DELIMITER = '\n'
                                     SKIP_HEADER = 1
                                     FIELD_OPTIONALLY_ENCLOSED_BY = '\"'
                                     TRIM_SPACE = TRUE
                                     ERROR_ON_COLUMN_COUNT_MISMATCH = false
                                     DATE_FORMAT = 'AUTO'
                                     TIMESTAMP_FORMAT = 'dd/mm/yyyy HH24:MI'
                                     NULL_IF = ('NULL')
                                     ESCAPE = '\\'
                                     ;
      ```
    c. Load Data
    
    ```
    copy into SRC_VIDEOSTART
                        from @my_csv_stage/video_data.csv.gz
                        file_format = (format_name = video_1)
                        on_error = 'skip_file';
    ```
    
2.  Clean data in Intermediate tables
    
    ```
    02_Clean_Stage_Table.sql
    ```
3.  Wash data in SRC_VIDEOSTART and load into STG_VIDEOSTART

    ```
    03_Wash_Data.sql
    ```
4.  Populate STG_DATE, STG_PLATFORM, STG_SITE and STG_VIDEO
    
    ```
    04_Populate_Stage.sql
    ```
5.  Insert staging data into dimension tables - DIM_DATE, DIM_PLATFORM, DIM_SITE and DIM_VIDEO

    ```
    05_Insert_Dim.sql
    ```
6.  Use STG_VIDEOSTART, DIM_DATE, DIM_PLATFORM, DIM_SITE and DIM_VIDEO to generate output data and append the data into fact table – FACT_VIDEOSTART
    
    ```
    06_Append_Fact.sql
    ```
