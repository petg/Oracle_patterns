------------------------------------------------------------------ drop project_log
whenever sqlerror continue;
drop table project_log;

------------------------------------------------------------------ create table project_log
whenever sqlerror exit sql.sqlcode;
create table project_log(
          id                                number              default to_number(to_char(systimestamp,'yyyymmddhh24missff4')),
          module                            varchar2(100)       default 'ALL',
          action                            varchar2(100)       default 'ALL',
          message                           varchar2(4000)      ,
          ---
          parameters                        varchar2(4000)      ,
          sql_rowcount                      number              ,
          ---
          msg_clob                          clob                ,
          ---
          error_code                        varchar2(4000)      ,
          error_stack                       varchar2(4000)      ,
          error_backtrace                   varchar2(4000)      ,
          ---
          log_level                         number              ,
          execution_time                    interval day to second(5),
          ---
          session_id                        number              ,
          process_id                        number              ,
          subprocess_id                     number              ,
          parent_process_id                 number              
          ---
          )
--column store compress for query high    --EXADATA only
row store compress advanced
lob(msg_clob) store as securefile (compress high)
/
          
