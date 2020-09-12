unit model.entities.sessao;

interface

  type
    TSessao = class(TObject)
    private
      FIss: string;
      FSub: string;
    public
      property iss: string read FIss write FIss;
      property sub: string read FSub write FSub;

  end;

implementation

{ TSessao }


end.
