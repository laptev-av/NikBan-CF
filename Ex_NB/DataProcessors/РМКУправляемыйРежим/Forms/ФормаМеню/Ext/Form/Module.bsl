﻿
&НаКлиенте
Процедура nb_ДекорацияСводныйОтчетНажатиеВместо(Элемент)
	ОчиститьСообщения();
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	
	КассоваяСменаССылка = ПолучитьКассовуюСмену();
	ПараметрыФормы = Новый Структура("Ключ", КассоваяСменаССылка);
	ОткрытьФорму("Документ.КассоваяСмена.ФормаОбъекта",ПараметрыФормы,,,,,, Режим);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКассовуюСмену()
	
	КассоваяСменаССылка = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	КассоваяСмена.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.КассоваяСмена КАК КассоваяСмена
		|ГДЕ
		|	НЕ КассоваяСмена.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	КассоваяСмена.МоментВремени УБЫВ";
	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		КассоваяСменаССылка = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЕсли;
	
	Возврат КассоваяСменаССылка

КонецФункции // ПолучитьКассовуюСмену()

&НаКлиенте
Процедура nb_nb_СОтчетПоСменеВместо(Команда)
	ОчиститьСообщения();
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	
	КассоваяСменаССылка = ПолучитьКассовуюСмену();
	ПараметрыФормы = Новый Структура("Ключ", КассоваяСменаССылка);
	ОткрытьФорму("Документ.КассоваяСмена.ФормаОбъекта",ПараметрыФормы,,,,,, Режим);	
КонецПроцедуры
