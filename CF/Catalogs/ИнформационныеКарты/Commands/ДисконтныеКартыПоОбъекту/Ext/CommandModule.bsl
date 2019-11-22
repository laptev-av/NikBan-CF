﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Справочник.ИнформационныеКарты.Форма.ФормаСписка.Открытие");

	ПараметрыФормы = Новый Структура;	
	ПараметрыФормы.Вставить("ВладелецКарты", ПараметрКоманды); 
	ПараметрыФормы.Вставить("ТолькоДисконтныеКарты", Истина);
	
	ОткрытьФорму("Справочник.ИнформационныеКарты.ФормаСписка", 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно);
		
КонецПроцедуры

#КонецОбласти
