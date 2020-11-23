--Copy File to Stage
CREATE STAGE "MY_CSV_STAGE";
put file://~/video_data.csv @my_csv_stage1 auto_compress=true;

--Create File Format
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

--Load Data
copy into SRC_VIDEOSTART
                        from @my_csv_stage/video_data.csv.gz
                        file_format = (format_name = video_1)
                        on_error = 'skip_file';
