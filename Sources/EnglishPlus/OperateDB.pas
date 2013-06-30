unit OperateDB;

interface

uses
  Data.DB, DBAccess, Uni, UniProvider, SQLiteUniProvider, BaseClassLibrary,
  Vcl.Forms, System.SysUtils, Datasnap.Provider,
  System.Variants, Generics.Collections, System.StrUtils;

const
  DBFileName = 'EnglishPlus';

type
  TDBOperator = class
  private
    FConnection: TUniConnection;
    function GetOpenConnection: TUniConnection;
  public
    constructor Create;
    destructor Destroy; override;

    function GetMaxID(TableName: string): Integer;
    function SetMaxID(TableName: string): Integer;

    function OpenSQL(SQL: string; P: TParams = nil): OleVariant;
    procedure ExecSQL(SQL: string; P: TParams = nil);

    function GetWordInfo(WordName: string): TWordInfo;
    function GetWordInfos(WordName: string): TList<TWordInfo>;
    procedure SaveWordInfo(AWordInfo: TWordInfo);
    procedure DeleteWordInfo(AWordInfo: TWordInfo);

    function GetRootInfo(RootName: string): TList<TRootInfo>;
    function GetRootInfos(RootName: string): TList<TRootInfo>;
    procedure SaveRootInfo(ARootInfo: TRootInfo);
    procedure DeleteRootInfo(ARootInfo: TRootInfo);

    function GetWordInterpre(WordName: string): TList<TWordInterpre>;
    procedure SaveWordInterpre(AWordInterpre: TWordInterpre);
    procedure DeleteWordInterpre(AWordInterpre: TWordInterpre);

    function GetWordSentence(WordName: string): TList<TWordSentence>;
    procedure SaveWordSentence(AWordSentence: TWordSentence);
    procedure DeleteWordSentence(AWordSentence: TWordSentence);

    function GetWordErive(WordName: string): TList<TWordErive>;
    procedure SaveWordErive(AWordErive: TWordErive);
    procedure DeleteWordErive(AWordErive: TWordErive);

    function GetWordStruct(WordName: string): TList<TWordStruct>;
    procedure SaveWordStruct(AWordStruct: TWordStruct);
    procedure DeleteWordStruct(AWordStruct: TWordStruct);
  end;

var
  DBOperator: TDBOperator;

implementation

{ TDBOperator }

constructor TDBOperator.Create;
begin
  FConnection := TUniConnection.Create(nil);
  FConnection.ProviderName := 'SQLite';
  FConnection.Database := ExtractFilePath(Application.ExeName)+DBFileName;
end;

procedure TDBOperator.DeleteRootInfo(ARootInfo: TRootInfo);
var
  sqlstr: string;
begin
//  sqlstr := 'delete from trootinfo where vc_root_name='''+ARootInfo.Root_Name+''''+
//    ' and i_root_seq='+IntToStr(ARootInfo.Root_Seq);
  sqlstr := 'delete from trootinfo where l_id='+IntToStr(ARootInfo.ID);
  ExecSQL(sqlstr);
end;

procedure TDBOperator.DeleteWordErive(AWordErive: TWordErive);
var
  sqlstr: string;
begin
  sqlstr := 'delete from tworderive where l_id='+IntToStr(AWordErive.Id);
  ExecSQL(sqlstr);
end;

procedure TDBOperator.DeleteWordInfo(AWordInfo: TWordInfo);
var
  sqlstr: string;
begin
  sqlstr := 'delete from twordinfo where vc_word_name ='''+AWordInfo.Word_Name+'''';
  ExecSQL(sqlstr);
end;

procedure TDBOperator.DeleteWordInterpre(AWordInterpre: TWordInterpre);
var
  sqlstr: string;
begin
  sqlstr := 'delete from twordinterpre where l_id='+IntToStr(AWordInterpre.ID);
  ExecSQL(sqlstr);
end;

procedure TDBOperator.DeleteWordSentence(AWordSentence: TWordSentence);
var
  sqlstr: string;
begin
  sqlstr := 'delete from twordsentence where l_id='+IntToStr(AWordSentence.ID);
  ExecSQL(sqlstr);
end;

procedure TDBOperator.DeleteWordStruct(AWordStruct: TWordStruct);
var
  sqlstr: string;
begin
  sqlstr := 'delete from twordstruct where l_id = '+IntToStr(AWordStruct.ID);
  ExecSQL(sqlstr);
end;

destructor TDBOperator.Destroy;
begin
  FConnection.Free;
  inherited;
end;

procedure TDBOperator.ExecSQL(SQL: string; P: TParams);
var
  qry: TUniQuery;
begin
  qry := TUniQuery.Create(nil);
  try
    qry.Connection := GetOpenConnection;
    qry.SQL.Text := SQL;
    if Assigned(P) then
      qry.Params.AssignValues(P);
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

function TDBOperator.GetWordErive(WordName: string): TList<TWordErive>;
var
  qry: TUniQuery;
  we: TWordErive;
begin
  Result := TList<TWordErive>.Create;
  qry := TUniQuery.Create(nil);
  try
    qry.Connection := GetOpenConnection;
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('select * from tworderive where vc_word_name = '''+WordName+'''');
    qry.Open;
    while not qry.Eof do
    begin
      we := TWordErive.Create;
      we.Id := qry.FieldByName('L_ID').AsInteger;
      we.Word_Name := qry.FieldByName('VC_WORD_NAME').AsString;
      we.Derive_Class := qry.FieldByName('L_DERIVE_CLASS').AsInteger;
      we.Rule_Type := qry.FieldByName('L_RULE_TYPE').AsInteger;
      we.Derive_Word_Name := qry.FieldByName('VC_DERIVE_WORD_NAME').AsString;
      we.Moddate := qry.FieldByName('VC_MODI_DATE').AsString;
      we.Modifier := qry.FieldByName('VC_MODIFIER').AsString;
      Result.Add(we);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TDBOperator.GetWordInfo(WordName: string): TWordInfo;
var
  qry: TUniQuery;
begin
  Result := nil;
  qry := TUniQuery.Create(nil);
  try
    qry.Connection := GetOpenConnection;
    qry.Close;
    qry.SQL.Text := 'select * from twordinfo where vc_word_name = '''+WordName+'''';
    qry.Open;
    if qry.RecordCount > 0 then
    begin
      Result := TWordInfo.Create;
      Result.Word_Name := qry.FieldByName('VC_WORD_NAME').AsString;
      Result.Word_Initial := qry.FieldByName('VC_WORD_INITIAL').AsString;
      Result.Word_Level := qry.FieldByName('I_WORD_LEVEL').AsInteger;
      Result.En_Phonetic_Symbol := qry.FieldByName('VC_EN_PHONETIC_SYMBOL').AsString;
      Result.Am_Phonetic_Symbol := qry.FieldByName('VC_AM_PHONETIC_SYMBOL').AsString;
      Result.Moddate := qry.FieldByName('VC_MODI_DATE').AsString;
      Result.Modifier := qry.FieldByName('VC_MODIFIER').AsString;
    end;
  finally
    qry.Free;
  end;
end;

function TDBOperator.GetWordInfos(WordName: string): TList<TWordInfo>;
var
  qry: TUniQuery;
  W: TWordInfo;
begin
  Result := TList<TWordInfo>.Create;
  qry := TUniQuery.Create(nil);
  try
    qry.Connection := GetOpenConnection;
    qry.Close;
    qry.SQL.Text := 'select * from twordinfo where vc_word_name like '''+WordName+'%''';
    qry.Open;
    while not qry.Eof do
    begin
      W := TWordInfo.Create;
      W.Word_Name := qry.FieldByName('VC_WORD_NAME').AsString;
      W.Word_Initial := qry.FieldByName('VC_WORD_INITIAL').AsString;
      W.Word_Level := qry.FieldByName('I_WORD_LEVEL').AsInteger;
      W.En_Phonetic_Symbol := qry.FieldByName('VC_EN_PHONETIC_SYMBOL').AsString;
      W.Am_Phonetic_Symbol := qry.FieldByName('VC_AM_PHONETIC_SYMBOL').AsString;
      W.Moddate := qry.FieldByName('VC_MODI_DATE').AsString;
      W.Modifier := qry.FieldByName('VC_MODIFIER').AsString;
      Result.Add(W);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TDBOperator.GetWordInterpre(WordName: string): TList<TWordInterpre>;
var
  qry: TUniQuery;
  wi: TWordInterpre;
begin
  Result := TList<TWordInterpre>.Create;
  qry := TUniQuery.Create(nil);
  try
    qry.Connection := GetOpenConnection;
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('select * from twordinterpre where vc_word_name ='''+WordName+'''');
    qry.Open;
    while not qry.Eof do
    begin
      wi := TWordInterpre.Create;
      wi.ID := qry.FieldByName('L_ID').AsInteger;
      wi.Word_Name := qry.FieldByName('VC_WORD_NAME').AsString;
      wi.Word_Attri := qry.FieldByName('VC_WORD_ATTRI').AsString;
      wi.En_Meaning := qry.FieldByName('VC_EN_MEANING').AsString;
      wi.Cn_Meaning := qry.FieldByName('VC_CN_MEANING').AsString;
      wi.Moddate := qry.FieldByName('VC_MODI_DATE').AsString;
      wi.Modifier := qry.FieldByName('VC_MODIFIER').AsString;
      Result.Add(wi);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TDBOperator.GetWordSentence(WordName: string): TList<TWordSentence>;
var
  qry: TUniQuery;
  ws: TWordSentence;
begin
  Result := TList<TWordSentence>.Create;
  qry := TUniQuery.Create(nil);
  try
    qry.Connection := GetOpenConnection;
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('select * from twordsentence where vc_word_name='''+WordName+'''');
    qry.Open;
    while not qry.Eof do
    begin
      ws := TWordSentence.Create;
      ws.ID := qry.FieldByName('L_ID').AsInteger;
      ws.Word_Name := qry.FieldByName('VC_WORD_NAME').AsString;
      ws.Wordattri := qry.FieldByName('VC_WORDATTRI').AsString;
      ws.En_Meaning := qry.FieldByName('VC_EN_MEANING').AsString;
      ws.Cn_Meaning := qry.FieldByName('VC_CN_MEANING').AsString;
      ws.Moddate := qry.FieldByName('VC_MODI_DATE').AsString;
      ws.Modifier := qry.FieldByName('VC_MODIFIER').AsString;
      Result.Add(ws);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TDBOperator.GetWordStruct(WordName: string): TList<TWordStruct>;
var
  qry: TUniQuery;
  ws: TWordStruct;
begin
  Result := TList<TWordStruct>.Create;
  qry := TUniQuery.Create(nil);
  try
    qry.Connection := GetOpenConnection;
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('select * from twordstruct where vc_word_name = '''+WordName+'''');
    qry.Open;
    while not qry.Eof do
    begin
      ws := TWordStruct.Create;
      ws.ID := qry.FieldByName('L_ID').AsInteger;
      ws.Word_Name := qry.FieldByName('VC_WORD_NAME').AsString;
      ws.Order := qry.FieldByName('I_ORDER').AsInteger;
      ws.Root_Name := qry.FieldByName('VC_ROOT_NAME').AsString;
      ws.Root_Seq := qry.FieldByName('I_ROOT_SEQ').AsInteger;
      Result.Add(ws);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TDBOperator.GetMaxID(TableName: string): Integer;
var
  qry: TUniQuery;
begin
  Result := 0;
  qry := TUniQuery.Create(nil);
  try
    qry.Connection := GetOpenConnection;
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('select l_max_id from tableid where vc_tablename='''+UpperCase(TableName)+'''');
    qry.Open;
    if qry.RecordCount > 0 then
      Result := qry.Fields[0].AsInteger;
  finally
    qry.Free;
  end;
end;

function TDBOperator.GetOpenConnection: TUniConnection;
begin
  if not FConnection.Connected then
    FConnection.Open;
  Result := FConnection;
end;

function TDBOperator.GetRootInfo(RootName: string): TList<TRootInfo>;
var
  qry: TUniQuery;
  R: TRootInfo;
begin
  Result := TList<TRootInfo>.Create;
  qry := TUniQuery.Create(nil);
  try
    qry.Connection := GetOpenConnection;
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('select * from trootinfo where vc_root_name = '''+RootName+'''');
    qry.Open;
    while not qry.Eof do
    begin
      R := TRootInfo.Create;
      R.Root_Name := qry.FieldByName('VC_ROOT_NAME').AsString;
      R.Root_Seq := qry.FieldByName('I_ROOT_SEQ').AsInteger;
      R.Phonetic_Symbol := qry.FieldByName('VC_PHONETIC_SYMBOL').AsString;
      R.En_Meaning := qry.FieldByName('VC_EN_MEANING').AsString;
      R.Cn_Meaning := qry.FieldByName('VC_CN_MEANING').AsString;
      R.Usage := qry.FieldByName('VC_USAGE').AsString;
      R.Root_Source := qry.FieldByName('I_ROOT_SOURCE').AsInteger;
      R.Root_Type := qry.FieldByName('I_ROOT_TYPE').AsInteger;
      R.Generatype := qry.FieldByName('I_GENERAL_TYPE').AsInteger;
      R.Postfix_Type := qry.FieldByName('I_POSTFIX_TYPE').AsInteger;
      R.Moddate := qry.FieldByName('VC_MODI_DATE').AsString;
      R.Modifier := qry.FieldByName('VC_MODIFIER').AsString;
      Result.Add(R);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TDBOperator.GetRootInfos(RootName: string): TList<TRootInfo>;
var
  qry: TUniQuery;
  R: TRootInfo;
begin
  Result := TList<TRootInfo>.Create;
  qry := TUniQuery.Create(nil);
  try
    qry.Connection := GetOpenConnection;
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('select * from trootinfo where vc_root_name like '''+RootName+'%''');
    qry.Open;
    while not qry.Eof do
    begin
      R := TRootInfo.Create;
      R.Root_Name := qry.FieldByName('VC_ROOT_NAME').AsString;
      R.Root_Seq := qry.FieldByName('I_ROOT_SEQ').AsInteger;
      R.Phonetic_Symbol := qry.FieldByName('VC_PHONETIC_SYMBOL').AsString;
      R.En_Meaning := qry.FieldByName('VC_EN_MEANING').AsString;
      R.Cn_Meaning := qry.FieldByName('VC_CN_MEANING').AsString;
      R.Usage := qry.FieldByName('VC_USAGE').AsString;
      R.Root_Source := qry.FieldByName('I_ROOT_SOURCE').AsInteger;
      R.Root_Type := qry.FieldByName('I_ROOT_TYPE').AsInteger;
      R.Generatype := qry.FieldByName('I_GENERAL_TYPE').AsInteger;
      R.Postfix_Type := qry.FieldByName('I_POSTFIX_TYPE').AsInteger;
      R.Moddate := qry.FieldByName('VC_MODI_DATE').AsString;
      R.Modifier := qry.FieldByName('VC_MODIFIER').AsString;
      Result.Add(R);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TDBOperator.OpenSQL(SQL: string; P: TParams): OleVariant;
var
  qry: TUniQuery;
  pvd: TDataSetProvider;
begin
  Result := Null;
  qry := TUniQuery.Create(nil);
  pvd := TDataSetProvider(nil);
  try
    pvd.DataSet := qry;
    qry.Connection := GetOpenConnection;
    qry.SQL.Text := SQL;
    if Assigned(P) then
      qry.Params.AssignValues(P);
    qry.Open;
    Result := pvd.Data;
  finally
    qry.Free;
    pvd.Free;
  end;
end;

procedure TDBOperator.SaveRootInfo(ARootInfo: TRootInfo);
var
  qry: TUniQuery;
  r_seq: Integer;
begin
  if ARootInfo.Root_Name = '' then
    Exit;

  qry := TUniQuery.Create(nil);
  try
    qry.Connection := GetOpenConnection;

    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('select * from trootinfo where vc_root_name ='''+ARootInfo.Root_Name+'''');
    qry.SQL.Add('order by i_root_seq desc');
    qry.Open;

    if qry.RecordCount = 0 then begin
      r_seq := 1;
      qry.Append;
      qry.FieldByName('l_id').Value := SetMaxID('trootinfo');
    end else begin
      r_seq := qry.FieldByName('I_ROOT_SEQ').AsInteger + 1;
      if qry.Locate('i_root_seq', ARootInfo.Root_Seq, [loCaseInsensitive, loPartialKey]) then
        qry.Edit
      else begin
        qry.Append;
        qry.FieldByName('l_id').Value := SetMaxID('trootinfo');
        ARootInfo.ID := qry.FieldByName('l_id').AsInteger;
      end;
    end;

    qry.FieldByName('VC_ROOT_NAME').Value := ARootInfo.Root_Name;
    qry.FieldByName('I_ROOT_SEQ').Value := r_seq;
    qry.FieldByName('VC_PHONETIC_SYMBOL').Value := ARootInfo.Phonetic_Symbol;
    qry.FieldByName('VC_EN_MEANING').Value := ARootInfo.En_Meaning;
    qry.FieldByName('VC_CN_MEANING').Value := ARootInfo.Cn_Meaning;
    qry.FieldByName('VC_USAGE').Value := ARootInfo.Usage;
    qry.FieldByName('I_ROOT_SOURCE').Value := ARootInfo.Root_Source;
    qry.FieldByName('I_ROOT_TYPE').Value := ARootInfo.Root_Type;
    qry.FieldByName('I_GENERAL_TYPE').Value := ARootInfo.Generatype;
    qry.FieldByName('I_POSTFIX_TYPE').Value := ARootInfo.Postfix_Type;
    qry.FieldByName('VC_MODI_DATE').Value := ARootInfo.Moddate;
    qry.FieldByName('VC_MODIFIER').Value := ARootInfo.Modifier;

    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TDBOperator.SaveWordErive(AWordErive: TWordErive);
var
  qry: TUniQuery;
begin
  qry := TUniQuery.Create(nil);
  try
    qry.Connection := GetOpenConnection;
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('select * from tworderive where l_id='+IntToStr(AWordErive.Id));
    qry.Open;
    if qry.RecordCount = 0 then
    begin
      qry.Append;
      qry.FieldByName('l_id').Value := SetMaxID('tworderive');
      AWordErive.Id := qry.FieldByName('l_id').AsInteger;
    end else
      qry.Edit;
    qry.FieldByName('VC_WORD_NAME').Value := AWordErive.Word_Name;
    qry.FieldByName('L_DERIVE_CLASS').Value := AWordErive.Derive_Class;
    qry.FieldByName('L_RULE_TYPE').Value := AWordErive.Rule_Type;
    qry.FieldByName('VC_DERIVE_WORD_NAME').Value := AWordErive.Derive_Word_Name;
    qry.FieldByName('VC_MODI_DATE').Value := AWordErive.Moddate;
    qry.FieldByName('VC_MODIFIER').Value := AWordErive.Modifier;
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TDBOperator.SaveWordInfo(AWordInfo: TWordInfo);
var
  qry: TUniQuery;
begin
  if AWordInfo.Word_Name = '' then
    Exit;
  qry := TUniQuery.Create(nil);
  try
    qry.Connection := GetOpenConnection;
    qry.Close;
    qry.SQL.Text := 'select * from twordinfo where vc_word_name='''+AWordInfo.Word_Name+'''';
    qry.Open;

    if qry.RecordCount = 0 then
      qry.Append
    else
      qry.Edit;

    qry.FieldByName('VC_WORD_NAME').Value := AWordInfo.Word_Name;
    qry.FieldByName('VC_WORD_INITIAL').Value := AWordInfo.Word_Initial;
    qry.FieldByName('I_WORD_LEVEL').Value := AWordInfo.Word_Level;
    qry.FieldByName('VC_EN_PHONETIC_SYMBOL').Value := AWordInfo.En_Phonetic_Symbol;
    qry.FieldByName('VC_AM_PHONETIC_SYMBOL').Value := AWordInfo.Am_Phonetic_Symbol;
    qry.FieldByName('VC_MODI_DATE').Value := AWordInfo.Moddate;
    qry.FieldByName('VC_MODIFIER').Value := AWordInfo.Modifier;

    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TDBOperator.SaveWordInterpre(AWordInterpre: TWordInterpre);
var
  qry: TUniQuery;
begin
  qry := TUniQuery.Create(nil);
  try
    qry.Connection := GetOpenConnection;
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('select * from twordinterpre where l_id = '+IntToStr(AWordInterpre.ID));
    qry.Open;

    if qry.RecordCount = 0 then begin
      qry.Append;
      qry.FieldByName('l_id').Value := SetMaxID('twordinterpre');
      AWordInterpre.ID := qry.FieldByName('l_id').AsInteger;
    end else
      qry.Edit;
    qry.FieldByName('VC_WORD_NAME').Value := AWordInterpre.Word_Name;
    qry.FieldByName('VC_WORD_ATTRI').Value := AWordInterpre.Word_Attri;
    qry.FieldByName('VC_EN_MEANING').Value := AWordInterpre.En_Meaning;
    qry.FieldByName('VC_CN_MEANING').Value := AWordInterpre.Cn_Meaning;
    qry.FieldByName('VC_MODI_DATE').Value := AWordInterpre.Moddate;
    qry.FieldByName('VC_MODIFIER').Value := AWordInterpre.Modifier;
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TDBOperator.SaveWordSentence(AWordSentence: TWordSentence);
var
  qry: TUniQuery;
begin
  qry := TUniQuery.Create(nil);
  try
    qry.Connection := GetOpenConnection;
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('select * from twordsentence where l_id='+IntToStr(AWordSentence.ID));
    qry.Open;

    if qry.RecordCount = 0 then
    begin
      qry.Append;
      qry.FieldByName('l_id').Value := SetMaxID('twordsentence');
      AWordSentence.ID := qry.FieldByName('l_id').AsInteger;
    end else
      qry.Edit;

    qry.FieldByName('VC_WORD_NAME').Value := AWordSentence.Word_Name;
    qry.FieldByName('VC_WORDATTRI').Value := AWordSentence.Wordattri;
    qry.FieldByName('VC_EN_MEANING').Value := AWordSentence.En_Meaning;
    qry.FieldByName('VC_CN_MEANING').Value := AWordSentence.Cn_Meaning;
    qry.FieldByName('VC_MODI_DATE').Value := AWordSentence.Moddate;
    qry.FieldByName('VC_MODIFIER').Value := AWordSentence.Modifier;

    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TDBOperator.SaveWordStruct(AWordStruct: TWordStruct);
var
  qry: TUniQuery;
begin
  qry := TUniQuery.Create(nil);
  try
    qry.Connection := GetOpenConnection;
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('select * from twordstruct where l_id = '+IntToStr(AWordStruct.ID));
    qry.Open;
    if qry.RecordCount = 0 then
    begin
      qry.Append;
      qry.FieldByName('L_ID').Value := SetMaxID('twordstruct');
      AWordStruct.ID := qry.FieldByName('L_ID').AsInteger;
    end else
      qry.Edit;
    qry.FieldByName('VC_WORD_NAME').Value := AWordStruct.Word_Name;
    qry.FieldByName('I_ORDER').Value := AWordStruct.Order;
    qry.FieldByName('VC_ROOT_NAME').Value := AWordStruct.Root_Name;
    qry.FieldByName('I_ROOT_SEQ').Value := AWordStruct.Root_Seq;
    qry.Post;
  finally
    qry.Free;
  end;
end;

function TDBOperator.SetMaxID(TableName: string): Integer;
var
  qry: TUniQuery;
  qry1: TUniQuery;
  MaxID: Integer;
begin
  Result := 0;
  qry := TUniQuery.Create(nil);
  try
    qry.Connection := GetOpenConnection;
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('select * from tableid order by l_id desc');
    qry.Open;

    if qry.RecordCount = 0 then
      MaxID := 0
    else
      MaxID := qry.FieldByName('l_id').AsInteger;

    if qry.Locate('vc_tablename', UpperCase(TableName),[loCaseInsensitive, loPartialKey]) then
      qry.Edit
    else begin
      qry1 := TUniQuery.Create(nil);
      try
        qry1.Connection := GetOpenConnection;
        qry1.Close;
        qry1.SQL.Clear;
        qry1.SQL.Add('select count(1) from '+TableName);
        try
          qry1.Open;
        except
          Exit;
        end;
      finally
        qry1.Free;
      end;
      qry.Append;
      qry.FieldByName('l_id').Value := MaxID + 1;
    end;

    qry.FieldByName('vc_tablename').Value := UpperCase(TableName);
    if qry.State = dsEdit then begin
      qry.FieldByName('l_max_id').Value := qry.FieldByName('l_max_id').AsInteger + 1;
    end else begin
      qry.FieldByName('l_max_id').Value := 1;
      qry.FieldByName('l_min_id').Value := 1;
    end;

    qry.Post;

    Result := qry.FieldByName('l_max_id').AsInteger;
  finally
    qry.Free;
  end;
end;

initialization
  DBOperator := TDBOperator.Create;

finalization
  DBOperator.Free;

end.
