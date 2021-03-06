create or replace type t_parameter force as object(
  ------------------------------------------------------------------ attributes
  name                            varchar2(100),
  type                            varchar2(100),
  c_value                         varchar2(100),
  n_value                         number,
  d_value                         date,
  t_value                         timestamp,
  ------------------------------------------------------------------ constructors
  constructor function t_parameter(
          ip_name                           varchar2,
          ip_value                          varchar2
          ) return self as result,
          
  constructor function t_parameter(
          ip_name                           varchar2,
          ip_value                          number
          ) return self as result,

  constructor function t_parameter(
          ip_name                           varchar2,
          ip_value                          date
          ) return self as result,

  constructor function t_parameter(
          ip_name                           varchar2,
          ip_value                          timestamp
          ) return self as result,
  ------------------------------------------------------------------ members
  member function toString return varchar2

)
/
create or replace type body t_parameter is
  
  ------------------------------------------------------------------ constructors
  constructor function t_parameter(
          ip_name                           varchar2,
          ip_value                          varchar2) return self as result
  is
  begin
    self.name           := ip_name;
    self.type           := 'VARCHAR2';
    self.c_value        := ip_value;
    return;
  end;
          
  constructor function t_parameter(
          ip_name                           varchar2,
          ip_value                          number
          ) return self as result
  is
  begin
    self.name           := ip_name;
    self.type           := 'NUMBER';
    self.n_value        := ip_value;
    return;
  end;

  constructor function t_parameter(
          ip_name                           varchar2,
          ip_value                          date
          ) return self as result
  is
  begin
    self.name           := ip_name;
    self.type           := 'DATE';
    self.d_value        := ip_value;
    return;
  end;

  constructor function t_parameter(
          ip_name                           varchar2,
          ip_value                          timestamp
          ) return self as result
  is
  begin
    self.name           := ip_name;
    self.type           := 'TIMESTAMP';
    self.t_value        := ip_value;
    return;
  end;
  ------------------------------------------------------------------ members
  member function toString return varchar2
  is
  begin
    return case self.type  when      'VARCHAR2'     then  self.c_value
                           when      'NUMBER'       then  to_char(self.n_value)
                           when      'DATE'         then  to_char(self.d_value, 'YYYYMMDD HH24:MM:SS')
                           when      'TIMESTAMP'    then  to_char(self.t_value, 'YYYYMMDD HH24:MM:SSFF5')
           end;
  end;

end;
/
