﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ВладелецСвойствСерий(ВидНоменклатуры) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПустаяСерия = Справочники.СерииНоменклатуры.СоздатьЭлемент();
	ПустаяСерия.ВидНоменклатуры = ВидНоменклатуры;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ПустаяСерия;
	
КонецФункции

#КонецОбласти

#КонецЕсли
