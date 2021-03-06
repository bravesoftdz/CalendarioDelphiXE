unit UFAgregarEvento;

interface

uses
umodconexion,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ComCtrls, Buttons, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ExtCtrls;

type
  TFAgregarEvento = class(TForm)
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Shape1: TShape;
    lnumero: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    DateTimePicker1: TDateTimePicker;
    ehoraini: TMaskEdit;
    ehorafin: TMaskEdit;
    EPropietarioPropiedad: TEdit;
    Epersonapaga: TEdit;
    btnnuevo: TBitBtn;
    btnbusarpersona: TBitBtn;
    CBDisponible: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CBChurrasquera: TCheckBox;
    CBSalon: TCheckBox;
    EMotivoEvento: TEdit;
    EAmenizado: TEdit;
    ECeulular: TEdit;
    ENumeroInvitados: TEdit;
    QSQL: TZQuery;
    QBuscar: TZQuery;
    Label13: TLabel;
    CBPropietarioInquilino: TComboBox;
    EColor: TComboBox;
    SpeedButton2: TSpeedButton;
    Label14: TLabel;
    Edireccion: TEdit;
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnnuevoClick(Sender: TObject);
    procedure btnbusarpersonaClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);

  private
    { Private declarations }
    function validar:boolean;
    procedure ClicAgregarPersonas;
    procedure ClicEditarPersonas;
    procedure ClicBuscarPersona;

    procedure Cargar;
    procedure Limpiar;

    function ObtenerCodigo(valor:string):string;
    function ObtenerFecha(valor:string):string;
    function ObtenerNumero(valor:string):string;

    function Obtener(valor:boolean):string;
    function ObtenerBol(valor:string):Boolean;

    function ValidarColor():boolean;
    function ValidarColorEditar():boolean;

  public
    { Public declarations }
    Dato,codigo,fecha,numero:string;
    pk_pagador,pk_contrato,pk_propiedad:string;

  end;

var
  FAgregarEvento: TFAgregarEvento;

implementation

uses UFBPropiedadPropietarioEvento, UFApersona, UFBPersona,
  UFSelectImprimirEvento;


{$R *.dfm}

procedure TFAgregarEvento.BitBtn1Click(Sender: TObject);
var
  aNo, Mes, Dia:Word;
begin
  DecodeDate(DateTimePicker1.DateTime, aNo, Mes, Dia);

  if validar then
  begin
    if codigo='' then
    begin
   
      
        with QSQL do
        begin
          SQL.Text:=''+
          ' update propiedad '+
          ' set nombre="'+Edireccion.Text+'" '+
          ' where '+
          ' pk_propiedad='+pk_propiedad+'; ';
          ExecSQL;
          
          SQL.Text:='select * from evento where pk_evento=0;';
          Open;
          Active:=True;

          Insert;
          FieldByName('fecha').value := DateTimePicker1.DateTime ;
          FieldByName('numero').value :=  numero;
          FieldByName('anio').value :=  ano;
          FieldByName('mes').value := mes;
          FieldByName('dia').value := dia;
          FieldByName('horainicio').value := ehoraini.Text;
          FieldByName('horafin').value := ehorafin.Text;
          FieldByName('fk_contrato').value := pk_contrato;
          //FieldByName('fk_propietario').value := pk_propietario;
          FieldByName('fk_persona').value := pk_pagador;
          FieldByName('disponible').value := CBDisponible.Text;

          FieldByName('colorChurrasquera').value := EColor.Text;
          FieldByName('checkChurrasquera').value := Obtener(CBChurrasquera.Checked) ;
          FieldByName('checkSalon').value := Obtener(CBSalon.Checked);
          FieldByName('MotivoEvento').value := EMotivoEvento.Text;
          FieldByName('NumeroInvitados').value := ENumeroInvitados.Text;
          FieldByName('CelularContacto').value := ECeulular.Text;
          FieldByName('Amenizado').value := EAmenizado.Text;
          FieldByName('PropietarioInquilino').value := CBPropietarioInquilino.Text;


          Post;

          SQL.Text:='select max(pk_evento) as id from evento;';
          Open;
          Active:=True;

          FSelectImprimirEvento.pk_evento:=FieldByName('id').AsString;
          FSelectImprimirEvento.pk_condominio:='1';
          FSelectImprimirEvento.ShowModal;
          //ShowMessage('Registrado Correctamente!!!');
          FAgregarEvento.Close;
        end;      


      
    end // end.codigo=''
    else
    begin
      if CBDisponible.Text='Libre' then
      begin

        with QSQL do
        begin
          SQL.Text:='select * from evento where pk_evento='+codigo+';';
          Open;
          Active:=True;

          Edit;
          //FieldByName('fecha').value := DateTimePicker1.DateTime ;
          //FieldByName('numero').value :=  numero;
          //FieldByName('anio').value :=  ano;
          //FieldByName('mes').value := mes;
          //FieldByName('dia').value := dia;
          FieldByName('horainicio').value := '00:00';
          FieldByName('horafin').value := '00:00';
          FieldByName('fk_contrato').value := 0;
          //FieldByName('fk_propietario').value := pk_propietario;
          FieldByName('fk_persona').value := '0';
          FieldByName('disponible').value := CBDisponible.Text;

          FieldByName('colorChurrasquera').value := '';
          FieldByName('checkChurrasquera').value := False;
          FieldByName('checkSalon').value := False;
          FieldByName('MotivoEvento').value := '';
          FieldByName('NumeroInvitados').value := '';
          FieldByName('CelularContacto').value := '';
          FieldByName('Amenizado').value := '';
          FieldByName('PropietarioInquilino').value := '';

          Post;


          FAgregarEvento.Close;
        end;


      end
      else
      begin

        with QSQL do
        begin
          SQL.Text:=''+
          ' update propiedad '+
          ' set nombre="'+Edireccion.Text+'" '+
          ' where '+
          ' pk_propiedad='+pk_propiedad+'; ';
          ExecSQL;
        end;

        with QSQL do
        begin
          SQL.Text:='select * from evento where pk_evento='+codigo+';';
          Open;
          Active:=True;

          Edit;
          FieldByName('fecha').value := DateTimePicker1.DateTime ;
          FieldByName('numero').value :=  numero;
          FieldByName('anio').value :=  ano;
          FieldByName('mes').value := mes;
          FieldByName('dia').value := dia;
          FieldByName('horainicio').value := ehoraini.Text;
          FieldByName('horafin').value := ehorafin.Text;
          FieldByName('fk_contrato').value := pk_contrato;
          //FieldByName('fk_propietario').value := pk_propietario;
          FieldByName('fk_persona').value := pk_pagador;
          FieldByName('disponible').value := CBDisponible.Text;

          FieldByName('colorChurrasquera').value := EColor.Text;
          FieldByName('checkChurrasquera').value := Obtener(CBChurrasquera.Checked) ;
          FieldByName('checkSalon').value := Obtener(CBSalon.Checked);
          FieldByName('MotivoEvento').value := EMotivoEvento.Text;
          FieldByName('NumeroInvitados').value := ENumeroInvitados.Text;
          FieldByName('CelularContacto').value := ECeulular.Text;
          FieldByName('Amenizado').value := EAmenizado.Text;
          FieldByName('PropietarioInquilino').value := CBPropietarioInquilino.Text;

          Post;

          FSelectImprimirEvento.pk_evento:=codigo;
          FSelectImprimirEvento.pk_condominio:='1';
          FSelectImprimirEvento.ShowModal;

          //ShowMessage('Modificado Correctamente!!!');
          FAgregarEvento.Close;
        end;

      end;


    end;

  end;
end;

procedure TFAgregarEvento.btnbusarpersonaClick(Sender: TObject);
begin
ClicBuscarPersona;
end;

procedure TFAgregarEvento.btnnuevoClick(Sender: TObject);
begin
ClicAgregarPersonas;
end;

procedure TFAgregarEvento.Cargar;
var fecha:string;
begin
  with QBuscar do
  begin
    SQL.Text:=''+
    ' SELECT  '+
    ' evento.pk_evento,  '+
    ' evento.fecha,  '+
    ' evento.anio,  '+
    ' evento.mes,  '+
    ' evento.dia,  '+
    ' evento.horainicio,  '+
    ' evento.horafin,  '+
    ' evento.fk_contrato,  '+
    ' evento.fk_propietario,  '+
    ' evento.fk_persona,  '+
    ' evento.disponible,  '+
    ' evento.colorChurrasquera,  '+
    ' evento.checkChurrasquera,  '+
    ' evento.checkSalon,  '+
    ' evento.MotivoEvento,  '+
    ' evento.NumeroInvitados,  '+
    ' evento.CelularContacto,  '+
    ' evento.Amenizado,  '+
    ' evento.PropietarioInquilino,  '+
    ' nombredueno(contrato.pk_contrato) as propietario,  '+
    ' propiedad.codigo,  '+
    ' propiedad.pk_propiedad, '+
    ' propiedad.nombre as direccion, '+
    ' (SELECT nombre from persona where pk_persona = evento.fk_persona) AS NombrePersona  '+
    ' FROM   '+
    '  evento left join persona on evento.fk_persona=persona.pk_persona   '+
    '  left join contrato on evento.fk_contrato=contrato.pk_contrato  '+
    '  left join propiedad on contrato.fk_propiedad=propiedad.pk_propiedad  '+
    
    ' WHERE  '+
    ' evento.pk_evento='+codigo+' ';
    Open;
    Active:=true;

    fecha := FieldByName('fecha').AsString;
    DateTimePicker1.DateTime:=FieldByName('fecha').AsDateTime;
    ehoraini.Text:=FieldByName('horainicio').AsString;
    ehorafin.Text:=FieldByName('horafin').AsString;
    pk_contrato:=FieldByName('fk_contrato').AsString;
    pk_pagador:=FieldByName('fk_persona').AsString;
    Epersonapaga.Text:=FieldByName('NombrePersona').AsString;
    EPropietarioPropiedad.Text:=FieldByName('codigo').AsString +'|'+FieldByName('propietario').AsString;


    EColor.Text := FieldByName('colorChurrasquera').AsString;
    CBChurrasquera.Checked := ObtenerBol( FieldByName('checkChurrasquera').AsString);
    CBSalon.Checked := ObtenerBol( FieldByName('checkSalon').AsString);
    EMotivoEvento.Text := FieldByName('MotivoEvento').AsString;
    ENumeroInvitados.Text := FieldByName('NumeroInvitados').AsString;
    ECeulular.Text := FieldByName('CelularContacto').AsString;
    EAmenizado.Text := FieldByName('Amenizado').AsString;
    CBDisponible.Text:=FieldByName('disponible').AsString;
    CBPropietarioInquilino.Text := FieldByName('PropietarioInquilino').AsString;

    Edireccion.Text:=FieldByName('direccion').AsString;
    pk_propiedad:=FieldByName('pk_propiedad').AsString;

  end;

end;

procedure TFAgregarEvento.ClicAgregarPersonas;
begin
  FApersona.op:='nuevo';
  FApersona.listarpropietario('1');
  FApersona.pk_propietario:='';
  FApersona.ShowModal;
  if FApersona.pk_propietario<>'' then
  begin
    pk_pagador:=FApersona.pk_propietario;
    Epersonapaga.Text:=FApersona.nombre;
  end;
end;

procedure TFAgregarEvento.ClicBuscarPersona;
begin
  FBPersona.pk_persona:='';
  FBPersona.Position:=poScreenCenter;
  FBPersona.ShowModal;
  if FBPersona.pk_persona<>'' then
  begin
    pk_pagador:=FBPersona.pk_persona;
    Epersonapaga.Text:=FBPersona.nombre;
  end;
end;


procedure TFAgregarEvento.ClicEditarPersonas;
begin
 if pk_pagador<>'' then
 begin
  FApersona.op:='Editar';
  FApersona.listarpropietario(pk_pagador);
  FApersona.pk_propietario:=pk_pagador;
  FApersona.ShowModal;
  if FApersona.pk_propietario<>'' then
  begin
    pk_pagador:=FApersona.pk_propietario;
    Epersonapaga.Text:=FApersona.nombre;
  end;
 end;
end;

procedure TFAgregarEvento.FormShow(Sender: TObject);

begin
  Limpiar;

  codigo:=ObtenerCodigo(Dato);
  fecha:=ObtenerFecha(Dato);
  numero:=ObtenerNumero(Dato);

  lnumero.Caption := numero;

  if codigo<>'' then
  begin
    Cargar;
  end
  else
  begin
    DateTimePicker1.DateTime:=StrToDate(fecha);
  end;
end;

procedure TFAgregarEvento.Limpiar;
begin
  codigo:='';
  fecha:='';
  numero:='';
  pk_pagador:='';
  pk_contrato:='';

  ehoraini.Text:='';
  ehorafin.Text:='';
  EPropietarioPropiedad.Text:='';
  Epersonapaga.Text:='';
  CBDisponible.Text:='';

    EColor.Text := '';
    CBChurrasquera.Checked := false;
    CBSalon.Checked := false;
    EMotivoEvento.Text := '';
    ENumeroInvitados.Text := '';
    ECeulular.Text := '';
    EAmenizado.Text := '';
    CBPropietarioInquilino.Text:='';

end;

function TFAgregarEvento.Obtener(valor: boolean): string;
begin
  if valor then
    Result:='X'
  else
    Result:='';
end;

function TFAgregarEvento.ObtenerBol(valor: string): Boolean;
begin

    Result:=False;

  if valor='X' then
    Result:=True


end;

function TFAgregarEvento.ObtenerCodigo(valor: string): string;
var
i:Integer;
begin
  i:=1;
  while (i<=length(valor))and(valor[i]<>'|') do
  begin
    Result:=Result+valor[i];
    inc(i);
  end;
end;

function TFAgregarEvento.ObtenerFecha(valor: string): string;
var
i:Integer;
begin
  i:=1;
  while (i<=length(valor))and(valor[i]<>'|') do
  begin
    inc(i);
  end;

  Result:='';
  inc(i);
  while (i<=length(valor))and(valor[i]<>'|') do
  begin
    Result:=Result+valor[i];
    inc(i);
  end;
end;


function TFAgregarEvento.ObtenerNumero(valor: string): string;
var
i:Integer;
begin
  i:=1;
  while (i<=length(valor))and(valor[i]<>'|') do
  begin
    inc(i);
  end;

  Result:='';
  inc(i);
  while (i<=length(valor))and(valor[i]<>'|') do
  begin
    inc(i);
  end;

  Result:='';
  inc(i);
  while (i<=length(valor))and(valor[i]<>'|') do
  begin
    Result:=Result+valor[i];
    inc(i);
  end;

end;


procedure TFAgregarEvento.SpeedButton1Click(Sender: TObject);
begin
    FBPropiedadPropietarioEvento.Caption:='"Buscar propiedad"';
    FBPropiedadPropietarioEvento.op:='Agregar Evento';
    FBPropiedadPropietarioEvento.FHeiht:=Height;
    FBPropiedadPropietarioEvento.Height:=Height-30;
    FBPropiedadPropietarioEvento.pk_usuario:='1';
    FBPropiedadPropietarioEvento.pk_condominio:='1' ;
    FBPropiedadPropietarioEvento.ShowModal;

    if FBPropiedadPropietarioEvento.pk_contrato<>'' then
    begin
      EPropietarioPropiedad.Text:=FBPropiedadPropietarioEvento.propiedad +' | '+FBPropiedadPropietarioEvento.propietario;
      pk_contrato := FBPropiedadPropietarioEvento.pk_contrato;
      pk_propiedad:= FBPropiedadPropietarioEvento.pk_propiedad;
      Edireccion.Text :=FBPropiedadPropietarioEvento.propiedad;
    end;

end;

procedure TFAgregarEvento.SpeedButton2Click(Sender: TObject);
begin
ClicEditarPersonas;
end;

function TFAgregarEvento.validar: boolean;
begin
  result:=True;


  if ehoraini.Text='  :  ' then
  begin
    Result:=False;
    MessageDlgPos('ERROR: Ingrese Hora Inicio ', mtWarning, [mbOK], 0, -1, -1);
  end;

  if ehorafin.Text='  :  ' then
  begin
    Result:=False;
    MessageDlgPos('ERROR: Ingrese Hora Fin', mtWarning, [mbOK], 0, -1, -1);
  end;

  if pk_contrato='' then
  begin
    MessageDlgPos('ERROR: Seleccione propiedad, propietario', mtWarning, [mbOK], 0, -1, -1);
    Result:=False;
  end;


  if codigo='' then
  begin
    if ValidarColor()=False then
    begin
      MessageDlgPos('ERROR: Ese color o Numero ya esta en otra solicitud de reserva', mtWarning, [mbOK], 0, -1, -1);
      Result:=False;
    end;
  end
  else
  begin
    if ValidarColorEditar()=False then
    begin
      MessageDlgPos('ERROR: Ese color o Numero ya esta en otra solicitud de reserva', mtWarning, [mbOK], 0, -1, -1);
      Result:=False;
    end;  
  end;
  

  if pk_pagador='' then
  begin
    MessageDlgPos('ERROR: Seleccione persona solicitante de Reserva', mtWarning, [mbOK], 0, -1, -1);
    Result:=False;
  end;



  if codigo='' then
  begin
    if CBDisponible.Text='Libre' then
    begin
      MessageDlgPos('ERROR: Seleccion una opcion diferente de Libre', mtWarning, [mbOK], 0, -1, -1);
      Result:=False;
    end;
  end;

end;

function TFAgregarEvento.ValidarColor(): boolean;
begin
  with QSQL do
  begin
    SQL.Text:=''+
    ' SELECT   '+
    ' count(*) CANT '+
    ' FROM   '+
    ' evento  '+
    ' where  '+
    ' date(evento.fecha)=date(:fecha) and '+
    ' colorChurrasquera="'+EColor.Text+'" ';
    ParamByName('fecha').Value:=DateTimePicker1.DateTime;
    Open;
    Active:=True;
    if FieldByName('CANT').AsInteger=0 then
      Result:=True
    else
      result:=False;

  end;
end;

function TFAgregarEvento.ValidarColorEditar: boolean;
begin
  with QSQL do
  begin
    SQL.Text:=''+
    ' SELECT   '+
    ' count(*) CANT '+
    ' FROM   '+
    ' evento  '+
    ' where  '+
    ' date(evento.fecha)=date(:fecha) and '+
    ' colorChurrasquera="'+EColor.Text+'"  and pk_evento<>'+codigo;
    ParamByName('fecha').Value:=DateTimePicker1.DateTime;
    Open;
    Active:=True;
    if FieldByName('CANT').AsInteger=0 then
      Result:=True
    else
      result:=False;

  end;

end;

end.
