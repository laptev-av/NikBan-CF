﻿
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("КоличествоУпаковокРасхождения") И ТипЗнч(Параметры.КоличествоУпаковокРасхождения) = Тип("Число") Тогда
	
		Если Параметры.КоличествоУпаковокРасхождения > 0 Тогда
		
			СтандартнаяОбработка = Ложь;
			
			ДанныеВыбора = Новый СписокЗначений;
			ДанныеВыбора.Добавить(Перечисления.ВариантыУчетаРасхождений.НаСкладеОтправителя);
			ДанныеВыбора.Добавить(Перечисления.ВариантыУчетаРасхождений.НаСкладеПолучателя);
		
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры
