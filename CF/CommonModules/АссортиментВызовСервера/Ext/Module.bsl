﻿
#Область ПрограммныйИнтерфейс

// Функция получает значение функциональной опции "ИспользоватьТоварныеКатегорииИКвотыАссортимента".
// Возвращаемое значение: 
// 		Результат - Булево - значение функицональной опции "ИспользоватьТоварныеКатегорииИКвотыАссортимента".
Функция ИспользоватьТоварныеКатегорииИКвотыАссортимента() Экспорт
	
	Результат = ПолучитьФункциональнуюОпцию("ИспользоватьТоварныеКатегорииИКвотыАссортимента");
	Если Результат <> Истина Тогда
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

