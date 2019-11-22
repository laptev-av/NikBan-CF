﻿#Область ПрограммныйИнтерфейс

// Выполняется при запуске регламентного задания.
//
Процедура ПриСбореПоказателейСтатистикиКонфигурации() Экспорт
	
	
	
	
	
	
	
	
	
КонецПроцедуры

// Задает настройки, применяемые как умолчания для объектов подсистемы.
//
// Параметры:
//   Настройки - Структура - Коллекция настроек подсистемы. Реквизиты:
//       * ВключитьОповещение - Булево - Умолчание для оповещений пользователя:
//           Истина - По умолчанию оповещаем администратора системы, например, если нет подсистемы "Текущие дела".
//           Ложь   - По умолчанию не оповещаем администратора системы.
//           Значение по умолчанию: зависит от наличия подсистемы "Текущие дела".                              
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
