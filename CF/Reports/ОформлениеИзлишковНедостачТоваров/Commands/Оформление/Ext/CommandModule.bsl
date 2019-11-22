﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Основание = ЗапасыСерверВызовСервера.ПолучитьОснованиеОформленияИзлишковНедостачТоваров(ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура(
		"Отбор, КлючНазначенияИспользования, КлючВарианта, СформироватьПриОткрытии",
		Новый Структура("Основание",Основание),
		"ОформлениеИзлишковНедостачКонтекст",
		"ОформлениеИзлишковНедостачКонтекст",
		Истина);

	ОткрытьФорму("Отчет.ОформлениеИзлишковНедостачТоваров.Форма",
				ПараметрыФормы,
				ПараметрыВыполненияКоманды.Источник,
				ПараметрыВыполненияКоманды.Уникальность,
				ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры
