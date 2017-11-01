create or replace type t_action force as object(
  ------------------------------------------------------------------ attributes
  module_name                     varchar2(100),
  action_name                     varchar2(100),
  description                     varchar2(1000),
  started                         timestamp,
  parent_module                   varchar2(100),
  parent_action                   varchar2(100),
  parameters                      tt_parameter,
  ------------------------------------------------------------------ constructors
  constructor function t_action(
          ip_action_name                    varchar2,
          ip_description                    varchar2,
          ip_parameters                     tt_parameter           default null,
          ip_module_name                    varchar2               default null
          ) return self as result,
  ------------------------------------------------------------------ members
  member function get_parameters_string 
          return varchar2,
  member procedure action_end_success(
          ip_message                        varchar2               default null
          ),
  member procedure action_end_exception(
          ip_message                        varchar2               default null,
          ip_run_rollback                   boolean                default true,
          ip_raise_exception                boolean                default false
          ),
  member function getResult(
          ip_result                         varchar2
          ) return varchar2,
  member function getResult(
          ip_result                         number
          ) return number,
  member function getResult(
          ip_result                         date
          ) return date,
  member function getResult(
          ip_result                         timestamp
          ) return timestamp
)
/
create or replace type body t_action is


  ------------------------------------------------------------------ constructors
  constructor function t_action(
          ip_action_name                    varchar2,
          ip_description                    varchar2,
          ip_parameters                     tt_parameter           default null,
          ip_module_name                    varchar2               default null
          ) return self as result
  is
  begin
    self.action_name    := ip_action_name;
    self.description    := ip_description;
    self.parameters     := nvl(ip_parameters,tt_parameter());
    self.module_name    := ip_module_name;
    self.started        := systimestamp;
    ---
    dbms_application_info.read_module(
            module_name => self.parent_module,
            action_name => self.parent_action);
    ---
    if ip_module_name is not null
      then
        self.module_name := ip_module_name;
      else
        self.module_name := self.parent_module;
    end if;
    ---
    dbms_application_info.set_module(
            module_name => self.module_name,
            action_name => self.action_name);
    ---
    plog.put(
            ip_message         => 'Start: "'||self.description||'"',
            ip_log_level       => plog.C_LOG_LEVEL_DEBUG,
            ip_parameters      => self.get_parameters_string);
    return;
  end;
  ------------------------------------------------------------------ members
  ------------------------------------------------------------------
  ------------------------------------------------------------------
  member function get_parameters_string 
          return varchar2
  is
    lc_result             varchar2(4000)   := '';
  begin
    for i in 1 .. self.parameters.count 
      loop
       lc_result := substr(lc_result || self.parameters(i).toString || plog.C_CHR_END_OF_LINE,1,4000);
    end loop;
    return lc_result;
  end;
  ------------------------------------------------------------------
  member procedure action_end_success(
          ip_message                        varchar2               default null
          )
  is
  begin
    plog.put(
            ip_message         => 'Finished ('|| ip_message ||')',
            ip_log_level       => plog.C_LOG_LEVEL_DEBUG,
            ip_execution_time  => self.started);
    
    dbms_application_info.set_module(
            module_name        => self.parent_module,
            action_name        => self.parent_action);
  end;
  ------------------------------------------------------------------
  member procedure action_end_exception(
          ip_message                        varchar2               default null,
          ip_run_rollback                   boolean                default true,
          ip_raise_exception                boolean                default false
          )
  is
  begin
    plog.put(
            ip_message         => 'Error ('|| ip_message ||')',
            ip_log_level       => plog.C_LOG_LEVEL_ERROR,
            ip_error_code      => sqlcode,
            ip_error_stack     => dbms_utility.format_error_stack,
            ip_error_backtrace => dbms_utility.format_error_backtrace,
            ip_execution_time  => self.started);
    ---
    if ip_run_rollback then
      rollback;
    end if;
    if ip_raise_exception then
      raise_application_error(-20101,'Procedure raise error.');
    end if;
    
    dbms_application_info.set_module(
            module_name        => self.parent_module,
            action_name        => self.parent_action);
  end;
  ------------------------------------------------------------------ getResult
  member function getResult(
          ip_result                         varchar2
          ) return varchar2
  is
  begin
    plog.put(
            ip_message        => 'Finished. Return result:"'|| ip_result ||'"', 
            ip_log_level      => plog.C_LOG_LEVEL_DEBUG, 
            ip_execution_time => self.started);
    return ip_result;
  end;
  member function getResult(
          ip_result                         number
          ) return number
  is
  begin
    plog.put(
            ip_message        => 'Finished. Return result:"'|| to_char(ip_result) ||'"', 
            ip_log_level      => plog.C_LOG_LEVEL_DEBUG, 
            ip_execution_time => self.started);
    return ip_result;
  end;
  member function getResult(
          ip_result                         date
          ) return date
  is
  begin
    plog.put(
            ip_message        => 'Finished. Return result:"'|| to_char(ip_result,'dd-mm-yyyy hh24:mi:ss') ||'"', 
            ip_log_level      => plog.C_LOG_LEVEL_DEBUG, 
            ip_execution_time => self.started);
    return ip_result;
  end;
  member function getResult(
          ip_result                         timestamp
          ) return timestamp
  is
  begin
    plog.put(
            ip_message        => 'Finished. Return result:"'|| to_char(ip_result,'dd-mm-yyyy hh24:mi:ss.ff5') ||'"', 
            ip_log_level      => plog.C_LOG_LEVEL_DEBUG, 
            ip_execution_time => self.started);
    return ip_result;
  end;
end;
/
