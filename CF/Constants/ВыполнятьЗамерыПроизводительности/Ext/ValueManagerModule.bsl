﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РегЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОчисткаЗамеровВремени);
	
	Если РегЗадание <> Неопределено Тогда
		РегЗадание.Использование = Значение;
		РегЗадание.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли