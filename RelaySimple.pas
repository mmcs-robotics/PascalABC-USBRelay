//  Пример упрощенной работы с библиотекой для управления USB-реле
//  функции открытия/закрытия/инвертирования порта
uses RelayABC;
begin
  //  Ждём указаний от пользователя
  WriteLn('1 - открыть порт (канал) 1, 2 - закрыть порт 1, q - выход :');
  while true do
    case ReadChar of
      '1' : OpenChannel(0,1);
      '2' : CloseChannel(0,1);
      'q' : break;
    end;
end.