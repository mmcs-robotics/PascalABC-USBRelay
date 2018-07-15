//  Модуль для работы с USB-реле. Работает только с определёнными моделями реле,
//  т.к. протокол "зашит" явным образом в dll-библиотеку.
//  Для работы требуются две dll: неуправляемая USB_RELAY_DEVICE.dll и
//  управляемая .NET-библиотека USBRelay.dll, обе библиотеки должны быть доступны.

//  Основывается на проекте https://github.com/pavel-a/usb-relay-hid 
//  Управляемая библиотека реализована в проекте https://github.com/mmcs-robotics/USB-Relay

//  Автор модуля Пучкин М.В., 2018

unit RelayABC;

interface
//  Подключаем dll для работы с реле
{$reference USBRelay.dll}

/// <summary>
/// Открывает указанный канал(порт) на заданном реле.
/// </summary>
/// <param name="deviceIndex">Номер устройства, нумерация с 0</param>
/// <param name="channelIndex">Номер канала (порта), нумерация с 1</param>
/// <returns></returns>
function OpenChannel(deviceIndex, channelIndex : integer) : boolean;

/// <summary>
/// Закрывает указанный канал(порт) на заданном реле.
/// </summary>
/// <param name="deviceIndex">Номер устройства, нумерация с 0</param>
/// <param name="channelIndex">Номер канала (порта), нумерация с 1</param>
/// <returns></returns>
function CloseChannel(deviceIndex, channelIndex : integer) : boolean;

/// <summary>
/// Инвертирует указанный канал(порт) на заданном реле.
/// </summary>
/// <param name="deviceIndex">Номер устройства, нумерация с 0</param>
/// <param name="channelIndex">Номер канала (порта), нумерация с 1</param>
/// <returns></returns>

function InvertChannel(deviceIndex, channelIndex : integer) : boolean;

type RelayManager = class
  /// <summary>
  /// Инициализация библиотеки работы с реле.
  /// </summary>
  /// <returns>True в случае успешного завершения</returns>
  class function InitRelays : boolean;
  /// <summary>
  /// Финализирует библиотеку - очистка списка реле.
  /// </summary>
  class procedure CloseRelays;
  /// <summary>
  /// Была ли успешна инициализация списка реле.
  /// </summary>
  /// <returns></returns>
  class function RelaysInited : boolean;
  /// <summary>
  /// Количество устройств реле, обнаруженных в системе.
  /// </summary>
  /// <returns></returns>
  class function RelaysCount : integer;
  /// <summary>
  /// Устанавливает активное реле из списка обнаруженных в системе (индексация с 0).
  /// </summary>
  /// <param name="deviceIndex">Индекс (номер) устройства реле</param>
  /// <returns></returns>
  class function SelectRelay(deviceIndex : integer) : boolean;
  /// <summary>
  /// Инициализирует работу с активным реле, выбранным функцией Select.
  /// </summary>
  /// <returns></returns>
  class function OpenRelay : boolean;
  /// <summary>
  /// Инициализирует активное реле из списка установленных в системе.
  /// </summary>
  /// <param name="deviceIndex">Индекс устройства в списке обнаруженных в системе, нумерация с 0</param>
  /// <returns></returns>
  class function OpenRelay(deviceIndex : integer) : boolean;
  /// <summary>
  /// Статус портов активного и открытого реле в виде целого, где каждый бит показывает статус порта.
  /// 0 - закрыт, 1 - открыт.
  /// </summary>
  /// <returns></returns>
  class function RelayStatus : integer;
  /// <summary>
  /// Количество портов активного реле (устройство должны быть открыто).
  /// </summary>
  /// <returns></returns>
  class function ChannelsCount : integer;
  /// <summary>
  /// Идентификатор текущего реле (строка, как правило 5 символов).
  /// </summary>
  /// <returns></returns>
  class function RelaySerial : string;
  /// <summary>
  /// Номер (индекс) активного реле, нумерация с 0.
  /// </summary>
  /// <returns></returns>
  class function CurrentRelayIndex : integer;
  /// <summary>
  /// Закрывает активное реле.
  /// </summary>
  /// <returns></returns>
  class function CloseRelay : boolean;
  /// <summary>
  /// Открывает указанный канал на активном устройстве.
  /// </summary>
  /// <param name="channelIndex">Номер порта (канала), индексация с 1</param>
  /// <returns></returns>
  class function OpenChannel(channelIndex : integer) : boolean;
  /// <summary>
  /// Закрывает указанный канал на активном устройстве.
  /// </summary>
  /// <param name="channelIndex">Номер порта (канала), индексация с 1</param>
  /// <returns></returns>
  class function CloseChannel(channelIndex : integer) : boolean;
  /// <summary>
  /// Открывает все порты (каналы) на активном устройстве.
  /// </summary>
  /// <returns></returns>
  class function OpenAllChannels : boolean;
  /// <summary>  
  /// Закрывает все порты (каналы) на активном устройстве.
  /// </summary>
  /// <returns></returns>
  class function CloseAllChannels : boolean;
  /// <summary>
  /// Проверяет, открыт ли указанный канал (порт) активного устройства.
  /// </summary>
  /// <returns></returns>
  class function ChannelOpened(channelIndex : integer) : boolean;  
end;

implementation

function OpenChannel(deviceIndex, channelIndex : integer) : boolean;
begin
  Result := USB.RelayManager.Open(deviceIndex,channelIndex);
end;

function CloseChannel(deviceIndex, channelIndex : integer) : boolean;
begin
  Result := USB.RelayManager.Close(deviceIndex,channelIndex);
end;

function InvertChannel(deviceIndex, channelIndex : integer) : boolean;
begin
  Result := USB.RelayManager.Invert(deviceIndex,channelIndex);
end;

class function RelayManager.InitRelays : boolean;
begin
  Result := USB.RelayManager.Init;
end;

class procedure RelayManager.CloseRelays;
begin
  USB.RelayManager.Close;
end;

class function RelayManager.RelaysInited : boolean;
begin
  Result := USB.RelayManager.Inited;
end;

class function RelayManager.RelaysCount : integer;
begin
  Result := USB.RelayManager.DevicesCount;
end;

class function RelayManager.SelectRelay(deviceIndex : integer) : boolean;
begin
  Result := USB.RelayManager.SelectDevice(deviceIndex);
end;

class function RelayManager.OpenRelay : boolean;
begin
  Result := USB.RelayManager.OpenDevice;
end;

class function RelayManager.OpenRelay(deviceIndex : integer) : boolean;
begin
  Result := USB.RelayManager.OpenDevice(deviceIndex);
end;

class function RelayManager.RelayStatus : integer;
begin
  Result := USB.RelayManager.RelayStatus;
end;

class function RelayManager.ChannelsCount : integer;
begin
  Result := USB.RelayManager.ChannelsCount;
end;

class function RelayManager.RelaySerial : string;
begin
  Result := USB.RelayManager.RelaySerial;
end;

class function RelayManager.CurrentRelayIndex : integer;
begin
  Result := USB.RelayManager.CurrentDeviceIndex;
end;

class function RelayManager.CloseRelay : boolean;
begin
  Result := USB.RelayManager.CloseDevice;
end;

class function RelayManager.OpenChannel(channelIndex : integer) : boolean;
begin
  Result := USB.RelayManager.OpenChannel(channelIndex);
end;

class function RelayManager.CloseChannel(channelIndex : integer) : boolean;
begin
  Result := USB.RelayManager.CloseChannel(channelIndex);
end;

class function RelayManager.OpenAllChannels : boolean;
begin
  Result := USB.RelayManager.OpenAllChannels;
end;

class function RelayManager.CloseAllChannels : boolean;
begin
  Result := USB.RelayManager.CloseAllChannels;
end;

class function RelayManager.ChannelOpened(channelIndex : integer) : boolean;  
begin
  Result := USB.RelayManager.ChannelOpened(channelIndex);
end;

end.