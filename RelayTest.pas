uses RelayABC;

begin
  //  Инициализируем библиотеку
  RelayManager.InitRelays;
  //  Количество обнаруженных устройств
  WriteLn('Всего устройств обнаружено : ', RelayManager.RelaysCount);
  WriteLn('Открываем первое устройство...');
  //  Пытаемся открыть первое по порядку устройство
  if not RelayManager.OpenRelay(0) then
    begin
      WriteLn('Не могу открыть устройство для работы, завершаюсь');
      exit;
    end;
  //  Номер текущего устройства
  WriteLn('Номер текущего устройства       : ', RelayManager.CurrentRelayIndex);
  //  Строка-идентификатор текущего устройства
  WriteLn('Строка-идентификатор устройства : ', RelayManager.RelaySerial);
  //  Количество портов текущего устройства
  WriteLn('Количество каналов устройства   : ', RelayManager.ChannelsCount);
  //  Ждём указаний от пользователя
  WriteLn('1 - открыть порт (канал) 1, 2 - закрыть порт 1, q - выход :');
  while true do
    case ReadlnChar of
        '1' : begin
                WriteLn('Открываем порт ...');
                RelayManager.OpenChannel(1);
                WriteLn('Состояние порта 1 (открыт?) : ', RelayManager.ChannelOpened(1));
              end;
        '2' : begin
                WriteLn('Закрываем порт ...');
                RelayManager.CloseChannel(1);
                WriteLn('Состояние порта 1 (открыт?) : ', RelayManager.ChannelOpened(1));
              end;
        'q' : break;
    end;
  //  Финализируем работу библиотеки
  RelayManager.CloseRelays;
end.