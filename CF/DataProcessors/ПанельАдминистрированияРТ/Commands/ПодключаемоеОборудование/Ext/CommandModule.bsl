﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Обработка.ПанельАдминистрированияРТ.Форма.НастройкиПодключаемогоОборудования.Открытие");

	ОткрытьФорму(
		"Обработка.ПанельАдминистрированияРТ.Форма.НастройкиПодключаемогоОборудования",
		Новый Структура,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.ПанельАдминистрированияРТ.Форма.НастройкиПодключаемогоОборудования" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
