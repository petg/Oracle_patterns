create or replace package plog is

  ------------------------------------------------------------------ 
  ------------------------------------------------------------------ constants
  ------------------------------------------------------------------ 
  ------------------------------------------------------------------ log level
  C_LOG_LEVEL_ERROR                      constant number            := 1;
  C_LOG_LEVEL_WORNING                    constant number            := 2;
  C_LOG_LEVEL_DEBUG                      constant number            := 3;
  C_LOG_LEVEL_INFO                       constant number            := 4;

  C_CHR_END_OF_LINE                      constant varchar2(10)      := chr(10)||chr(13);

  ------------------------------------------------------------------ variables
  GLOBAL_LOG_LEVEL                       number                     := 4;


  ------------------------------------------------------------------ colls
  procedure put(
            ip_message                        varchar2,
            ip_log_level                      number           default C_LOG_LEVEL_INFO,
            ---
            ip_module                         varchar2         default null,
            ip_action                         varchar2         default null,
            ip_parameters                     varchar2         default null,
            ip_sql_rowcount                   number           default null,
            ip_msg_clob                       clob             default null,
            ---
            ip_error_code                     varchar2         default null,
            ip_error_stack                    varchar2         default null,
            ip_error_backtrace                varchar2         default null,
            ---
            ip_parent_process_id              varchar2         default null,
            ip_execution_time                 timestamp        default null
            );
end plog;
/
create or replace package body plog is
  ------------------------------------------------------------------ session info
  C_SID                                  number;
  C_PID                                  varchar2(24);
  
------------------------------------------------------------------ code
procedure put(
          ip_message                        varchar2,
          ip_log_level                      number           default C_LOG_LEVEL_INFO,
          ---
          ip_module                         varchar2         default null,
          ip_action                         varchar2         default null,
          ip_parameters                     varchar2         default null,
          ip_sql_rowcount                   number           default null,
          ip_msg_clob                       clob             default null,
          ---
          ip_error_code                     varchar2         default null,
          ip_error_stack                    varchar2         default null,
          ip_error_backtrace                varchar2         default null,
          ---
          ip_parent_process_id              varchar2         default null,
          ip_execution_time                 timestamp        default null
          ) is
  pragma autonomous_transaction;
  lc_module_name                    varchar2(100);
  lc_action_name                    varchar2(100);
  
begin
  
  if  ip_log_level > plog.GLOBAL_LOG_LEVEL then
    commit;
    return;
  end if;
    
  dbms_application_info.read_module(
          module_name        => lc_module_name, 
          action_name        => lc_action_name);
  --
  lc_module_name := nvl(ip_module,lc_module_name);
  lc_action_name := nvl(ip_action,lc_action_name);
  --
  insert 
    into project_log(
          module, 
          action, 
          message, 
          parameters,
          log_level,
          sql_rowcount, 
          msg_clob, 
          error_code, 
          error_stack, 
          error_backtrace, 
          session_id, 
          process_id, 
          parent_process_id,
          execution_time
    )
  values (
          lc_module_name,
          lc_action_name,
          ip_message,
          ip_parameters,
          ip_log_level,
          ip_sql_rowcount,
          ip_msg_clob,
          ip_error_code,
          ip_error_stack,
          ip_error_backtrace,
          C_SID,
          C_PID,
          ip_parent_process_id,
          systimestamp - ip_execution_time
    );
  
  commit;
exception
  when others then
    rollback;
end;

------------------------------------------------------------------ init
procedure init_session 
is
begin
  select s.sid, s.process
    into C_SID, C_PID
    from v$session s
   where audsid = userenv('sessionid')
        ;
   
exception
  when others then 
    C_SID := 0;
    C_PID := '0';
end;
            
begin
  init_session;
end plog;
/
