﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Справочник.ИнформационныеКарты.Форма.ФормаСписка.Открытие");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТолькоРегистрационныеКарты", Истина);
	
	ОткрытьФорму("Справочник.ИнформационныеКарты.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		"РегистрационныеКарты",
		ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

#КонецОбласти
