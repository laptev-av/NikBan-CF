﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТаблицаПроизводители = ПолучитьИзВременногоХранилища(Параметры.АдресВоВременномХранилище);
	Производители.Загрузить(ТаблицаПроизводители);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицы

&НаКлиенте
Процедура ПроизводителиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ПроизводителиПроизводитель Тогда
		ТекущиеДанные = Элементы.Производители.ТекущиеДанные;
		
		ПоказатьЗначение(, ТекущиеДанные.Производитель);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
