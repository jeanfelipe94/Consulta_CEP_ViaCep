unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uFormat, Vcl.Buttons,
  REST.Types, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    MemTable: TFDMemTable;
    Memo1: TMemo;
    procedure SpeedButton1Click(Sender: TObject);
  private
    procedure ConsultarCEP(cep: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ConsultarCEP (cep: string);
begin
    if SomenteNumero(Edit1.Text).Length <> 8 then
    begin
      ShowMessage('CEP inv�lido');
    end;

    RESTRequest1.Resource := SomenteNumero(Edit1.Text) + '/json';
    RESTRequest1.Execute;

    if RESTRequest1.Response.StatusCode = 200 then
    begin
      if RESTRequest1.Response.Content.IndexOf('erro') > 0 then
          ShowMessage('CEP n�o encontrado.')
      else
      begin
          with MemTable do
          begin
              Memo1.Text := 'CEP: ' + FieldByName('cep').AsString + sLineBreak +
                            'Endere�o: ' + FieldByName('logradouro').AsString + sLineBreak +
                            'Bairro: ' + FieldByName('bairro').AsString + sLineBreak +
                            'Cidade: ' + FieldByName('localidade').AsString + sLineBreak +
                            'UF: ' + FieldByName('uf').AsString + sLineBreak +
                            'C�digo IBGE: ' + FieldByName('IBGE').AsString;
          end;
      end;

    end;

end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  ConsultarCEP(Edit1.Text);
end;

end.
