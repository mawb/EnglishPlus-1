unit BaseClassLibrary;

interface

uses
  Generics.Collections;

type
  TWordInfo=class
  private
    FWord_Name: string;
    FWord_Initial: string;
    FWord_Level: integer;
    FEn_Phonetic_Symbol: string;
    FAm_Phonetic_Symbol: string;
    FModdate: string;
    FModifier: string;
  public
    constructor Create;
    procedure Save;
    procedure Delete;

    class function GetWordInfo(WordName: string): TWordInfo;
    class function GetWordInfos(WordName: string): TList<TWordInfo>;

    property Word_Name: string read FWord_Name write FWord_Name;
    property Word_Initial: string read FWord_Initial write FWord_Initial;
    property Word_Level: integer read FWord_Level write FWord_Level;
    property En_Phonetic_Symbol: string read FEn_Phonetic_Symbol write FEn_Phonetic_Symbol;
    property Am_Phonetic_Symbol: string read FAm_Phonetic_Symbol write FAm_Phonetic_Symbol;
    property Moddate: string read FModdate write FModdate;
    property Modifier: string read FModifier write FModifier;
  end;

  TRootInfo=class
  private
    FRoot_Name: string;
    FRoot_Seq: integer;
    FPhonetic_Symbol: string;
    FEn_Meaning: string;
    FCn_Meaning: string;
    FUsage: string;
    FRoot_Source: integer;
    FRoot_Type: integer;
    FGeneratype: integer;
    FPostfix_Type: integer;
    FModdate: string;
    FModifier: string;
    FID: Integer;
  public
    constructor Create;
    procedure Save;
    procedure Delete;

    class function GetRootInfo(RootName: string): TList<TRootInfo>;
    class function GetRootInfos(RootName: string): TList<TRootInfo>;

    property ID: Integer read FID write FID;
    property Root_Name: string read FRoot_Name write FRoot_Name;
    property Root_Seq: integer read FRoot_Seq write FRoot_Seq;
    property Phonetic_Symbol: string read FPhonetic_Symbol write FPhonetic_Symbol;
    property En_Meaning: string read FEn_Meaning write FEn_Meaning;
    property Cn_Meaning: string read FCn_Meaning write FCn_Meaning;
    property Usage: string read FUsage write FUsage;
    property Root_Source: integer read FRoot_Source write FRoot_Source;
    property Root_Type: integer read FRoot_Type write FRoot_Type;
    property Generatype: integer read FGeneratype write FGeneratype;
    property Postfix_Type: integer read FPostfix_Type write FPostfix_Type;
    property Moddate: string read FModdate write FModdate;
    property Modifier: string read FModifier write FModifier;
  end;

  TWordInterpre=class
  private
    FWord_Name: string;
    FWord_Attri: string;
    FEn_Meaning: string;
    FCn_Meaning: string;
    FModdate: string;
    FModifier: string;
    FID: Integer;
  public
    constructor Create;
    procedure Save;
    procedure Delete;

    class function GetWordInterpre(WordName: string): TList<TWordInterpre>;

    property ID: Integer read FID write FID;
    property Word_Name: string read FWord_Name write FWord_Name;
    property Word_Attri: string read FWord_Attri write FWord_Attri;
    property En_Meaning: string read FEn_Meaning write FEn_Meaning;
    property Cn_Meaning: string read FCn_Meaning write FCn_Meaning;
    property Moddate: string read FModdate write FModdate;
    property Modifier: string read FModifier write FModifier;
  end;

  TWordSentence=class
  private
    FID: Integer;
    FWord_Name: string;
    FWordattri: string;
    FEn_Meaning: string;
    FCn_Meaning: string;
    FModdate: string;
    FModifier: string;
  public
    constructor Create;
    procedure Save;
    procedure Delete;

    class function GetWordSentence(WordName: string): TList<TWordSentence>;

    property ID: Integer read FID write FID;
    property Word_Name: string read FWord_Name write FWord_Name;
    property Wordattri: string read FWordattri write FWordattri;
    property En_Meaning: string read FEn_Meaning write FEn_Meaning;
    property Cn_Meaning: string read FCn_Meaning write FCn_Meaning;
    property Moddate: string read FModdate write FModdate;
    property Modifier: string read FModifier write FModifier;
  end;

  TWordErive=class
  private
    FId: integer;
    FWord_Name: string;
    FDerive_Class: integer;
    FRule_Type: integer;
    FDerive_Word_Name: string;
    FModdate: string;
    FModifier: string;
  public
    constructor Create;
    procedure Save;
    procedure Delete;
    class function GetWordErive(WordName: string): TList<TWordErive>;
    property Id: integer read FId write FId;
    property Word_Name: string read FWord_Name write FWord_Name;
    property Derive_Class: integer read FDerive_Class write FDerive_Class;
    property Rule_Type: integer read FRule_Type write FRule_Type;
    property Derive_Word_Name: string read FDerive_Word_Name write FDerive_Word_Name;
    property Moddate: string read FModdate write FModdate;
    property Modifier: string read FModifier write FModifier;
  end;

  TWordStruct=class
  private
    FWord_Name: string;
    FOrder: integer;
    FRoot_Name: string;
    FRoot_Seq: integer;
    FID: Integer;
  public
    constructor Create;
    procedure Save;
    procedure Delete;
    class function GetWordStruct(WordName: string): TList<TWordStruct>;
    property ID: Integer read FID write FID;
    property Word_Name: string read FWord_Name write FWord_Name;
    property Order: integer read FOrder write FOrder;
    property Root_Name: string read FRoot_Name write FRoot_Name;
    property Root_Seq: integer read FRoot_Seq write FRoot_Seq;
  end;


implementation

uses
  OperateDB;

{ TWordInfo }

constructor TWordInfo.Create;
begin
  FWord_Name := '';
  FWord_Initial := '';
  FWord_Level := 0;
  FEn_Phonetic_Symbol := '';
  FAm_Phonetic_Symbol := '';
  FModdate := '';
  FModifier := '';
end;

procedure TWordInfo.Delete;
begin
  DBOperator.DeleteWordInfo(Self);
end;

class function TWordInfo.GetWordInfo(WordName: string): TWordInfo;
begin
  Result := DBOperator.GetWordInfo(WordName);
  if not Assigned(Result) then
    Result := TWordInfo.Create;
end;

class function TWordInfo.GetWordInfos(WordName: string): TList<TWordInfo>;
begin
  Result := DBOperator.GetWordInfos(WordName);
end;

procedure TWordInfo.Save;
begin
  DBOperator.SaveWordInfo(Self);
end;

{ TRootInfo }

constructor TRootInfo.Create;
begin
  FID := 0;
  FRoot_Name := '';
  FRoot_Seq := 0;
  FPhonetic_Symbol := '';
  FEn_Meaning := '';
  FCn_Meaning := '';
  FUsage := '';
  FRoot_Source := 0;
  FRoot_Type := 0;
  FGeneratype := 0;
  FPostfix_Type := 0;
  FModdate := '';
  FModifier := '';
end;

procedure TRootInfo.Delete;
begin
  DBOperator.DeleteRootInfo(Self);
end;

class function TRootInfo.GetRootInfo(RootName: string): TList<TRootInfo>;
begin
  Result := DBOperator.GetRootInfo(RootName);
end;

class function TRootInfo.GetRootInfos(RootName: string): TList<TRootInfo>;
begin
  Result := DBOperator.GetRootInfos(RootName);
end;

procedure TRootInfo.Save;
begin
  DBOperator.SaveRootInfo(Self);
end;

{ TWordInterpre }

constructor TWordInterpre.Create;
begin
  FID := 0;
  FWord_Name := '';
  FWord_Attri := '';
  FEn_Meaning := '';
  FCn_Meaning := '';
  FModdate := '';
  FModifier := '';
end;

procedure TWordInterpre.Delete;
begin
  DBOperator.DeleteWordInterpre(Self);
end;

class function TWordInterpre.GetWordInterpre(
  WordName: string): TList<TWordInterpre>;
begin
  Result := DBOperator.GetWordInterpre(WordName);
end;

procedure TWordInterpre.Save;
begin
  DBOperator.SaveWordInterpre(Self);
end;

{ TWordSentence }

constructor TWordSentence.Create;
begin
  FID := 0;
  FWord_Name := '';
  FWordattri := '';
  FEn_Meaning := '';
  FCn_Meaning := '';
  FModdate := '';
  FModifier := '';
end;

procedure TWordSentence.Delete;
begin
  DBOperator.DeleteWordSentence(Self);
end;

class function TWordSentence.GetWordSentence(
  WordName: string): TList<TWordSentence>;
begin
  Result := DBOperator.GetWordSentence(WordName);
end;

procedure TWordSentence.Save;
begin
  DBOperator.SaveWordSentence(Self);
end;

{ TWordErive }

constructor TWordErive.Create;
begin
  FId := 0;
  FWord_Name := '';
  FDerive_Class := 0;
  FRule_Type := 0;
  FDerive_Word_Name := '';
  FModdate := '';
  FModifier := '';
end;

procedure TWordErive.Delete;
begin
  DBOperator.DeleteWordErive(Self);
end;

class function TWordErive.GetWordErive(WordName: string): TList<TWordErive>;
begin
  Result := DBOperator.GetWordErive(WordName);
end;

procedure TWordErive.Save;
begin
  DBOperator.SaveWordErive(Self);
end;

{ TWordStruct }

constructor TWordStruct.Create;
begin
  FWord_Name := '';
  FOrder := 0;
  FRoot_Name := '';
  FRoot_Seq := 0;
  FID := 0;
end;

procedure TWordStruct.Delete;
begin
  DBOperator.DeleteWordStruct(Self);
end;

class function TWordStruct.GetWordStruct(WordName: string): TList<TWordStruct>;
begin
  Result := DBOperator.GetWordStruct(WordName);
end;

procedure TWordStruct.Save;
begin
  DBOperator.SaveWordStruct(Self);
end;

end.
