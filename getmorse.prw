#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

WSRESTFUL getmorse DESCRIPTION 'Codifica texto em código Morse'

    WSMETHOD GET DESCRIPTION 'Codifica' WSSYNTAX '/getmorse/{text}'
END WSRESTFUL

WSMETHOD GET WSSERVICE getmorse
    Local cTexto     := ""
    Local cResultado := ""
    Local nI         := 0
    Local jResponse  := JsonObject():New()


    If Len(Self:aURLParms) > 0
        cTexto := Self:aURLParms[1]
    EndIf


    If Empty(cTexto)
        Self:SetStatus(400) 
        jResponse['errorId']  := 'ID001'
        jResponse['error']    := 'Texto vazio'
        jResponse['solution'] := 'Informe o texto na URL'
        Self:SetResponse(jResponse:ToJson())
        Return .T.
    EndIf

    cTexto := Upper(cTexto)

    For nI := 1 To Len(cTexto)
        cResultado += MapaMorse(Substr(cTexto, nI, 1)) + " "
    Next nI

    Self:SetContentType("application/json")
    Self:SetResponse('{"original": "' + cTexto + '", "morse": "' + AllTrim(cResultado) + '"}')

Return .T.

Static Function MapaMorse(cChar)
    Local aMorse := {}
    Local nPos   := 0 

    aMorse := {;
    {"A", ".-"},    {"B", "-..."},  {"C", "-.-."}, {"D", "-.."},  {"E", "."},;
    {"F", "..-."},  {"G", "--."},   {"H", "...."}, {"I", ".."},   {"J", ".---"},;
    {"K", "-.-"},   {"L", ".-.."},  {"M", "--"},   {"N", "-."},   {"O", "---"},;
    {"P", ".--."},  {"Q", "--.-"},  {"R", ".-."},  {"S", "..."},  {"T", "-"},;
    {"U", "..-"},   {"V", "...-"},  {"W", ".--"},  {"X", "-..-"}, {"Y", "-.--"},;
    {"Z", "--.."},  {" ", "/"},;
    {"0", "-----"}, {"1", ".----"}, {"2", "..---"}, {"3", "...--"},;
    {"4", "....-"}, {"5", "....."}, {"6", "-...."},;
    {"7", "--..."}, {"8", "---.."}, {"9", "----."}  ;
}

    

    nPos := AScan(aMorse, {|x| x[1] == cChar})
    
Return If(nPos > 0, aMorse[nPos][2], "?")
