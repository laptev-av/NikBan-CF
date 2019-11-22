﻿////////////////////////////////////////////////////////////////////////////////
// ОбменСКонтрагентамиКлиентСервер: механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает текстовое представление версии электронного документа.
//
// Параметры:
//  СсылкаНаВладельца - Ссылка - объект, состояние версии электронного документа которого необходимо получить.
//  ЭлементДоступен - Булево - установка гиперссылки.
//
// Возвращаемое значение:
//  Строка - текстовое представление.
//
Функция ПолучитьТекстСостоянияЭД(СсылкаНаВладельца, ЭлементДоступен = Истина) Экспорт
	
	Результат = ОбменСКонтрагентамиСлужебныйВызовСервера.ТекстСостоянияЭД(СсылкаНаВладельца, ЭлементДоступен);
	
	Возврат Результат;
	
КонецФункции

// Формирование текстового представления рекламы по ЭДО.
//
// Параметры:
//  ДополнительнаяИнформация - Структура - с полями:
//   * Картинка - Картинка - картинка из библиотеки картинок;
//   * Текст - Строка - форматированный текст надписи с навигационными ссылками.
//  МассивСсылок - Массив - список ссылок на объекты.
//
// Возвращаемое значение:
//  Строка - возврат строки рекламы.
//
Функция ПриВыводеНавигационнойСсылкиВФормеОбъектаИБ(ДополнительнаяИнформация, МассивСсылок) Экспорт
	
	Если Не ЗначениеЗаполнено(МассивСсылок) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ОбменСКонтрагентамиСлужебныйВызовСервера.ЕстьПравоНастройкиОбмена() Тогда
		Возврат "";
	КонецЕсли;
	
	ПараметрыЭД = Неопределено;
	Если Не ОбменСКонтрагентамиСлужебныйВызовСервера.НастройкаЭДСуществует(МассивСсылок[0], ПараметрыЭД) Тогда
		
		ТекстНавигационнойСсылки = "";
		ОбменСКонтрагентамиСлужебныйВызовСервера.ЗаполнитьТекстПриглашенияКЭДО(ТекстНавигационнойСсылки, ПараметрыЭД, МассивСсылок[0], Ложь);
		Если ЗначениеЗаполнено(ТекстНавигационнойСсылки) Тогда
			ШаблонНавигационнойСсылки = НСтр("ru = '<a href = ""Реклама1СЭДО"">%1</a>'");
			ДополнительнаяИнформация.Текст    = СтрШаблон(ШаблонНавигационнойСсылки, ТекстНавигационнойСсылки);
			ДополнительнаяИнформация.Картинка = БиблиотекаКартинок.ЭмблемаСервиса1СЭДО;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// В процедуре выполняются действия по служебным ЭД (извещение о получении, уведомление об уточнении):
// формирование, утверждение, подписание, отправка.
//
// Параметры:
//  МассивЭД - массив - содержит ссылки на ЭД, по которым требуется сформировать служебные ЭД (электронные
//    документы, владельцы обрабатываемых служебных ЭД).
//  ВидЭД - перечисление - вид ЭД, которые надо обработать (может принимать значения: Извещение о получении
//    и уведомление об уточнении).
//  ТекстУведомления - строка - текст уведомления, введенный пользователем, отклонившим ЭД (имеет смысл,
//    только для ВидЭД = УведомлениеОбУточнении).
//  ДопПараметры - структура - структура дополнительных параметров.
//  ОписаниеОповещения - ОписаниеОповещения - оповещение, вызываемое после выполнения метода.
//
Процедура СформироватьПодписатьИОтправитьСлужебныеЭД(МассивЭД,
	ВидЭД, ТекстУведомления = "", ДопПараметры = Неопределено, ОписаниеОповещения = Неопределено) Экспорт
	
	КолСформированных = 0;
	КолУтвержденных   = 0;
	КолПодписанных    = 0;
	КолПодготовленных = 0;
	КолОтправленных   = 0;
	// Структура соответствий содержит соответствия: соглашений и сертификатов подписи, соглашений и сертификатов авторизации,
	// сертификатов и структур параметров этих сертификатов (структура параметров сертификатов содержит: ссылку на сертификат,
	// признак "запомнить пароль к сертификату", пароль к сертификату, признак "отозван", отпечаток, файл сертификата, а так же
	// если этот сертификат используется для авторизации, то либо расшифрованный маркер, либо зашифрованный маркер или и то и другое).
	НемедленнаяОтправкаЭД = Неопределено;
	ВыполнятьКриптооперацииНаСервере = Неопределено;
	ОбменСКонтрагентамиСлужебныйВызовСервера.ИнициализироватьПеременные(
		ВыполнятьКриптооперацииНаСервере, НемедленнаяОтправкаЭД);
	ВыполнитьОповещение = (ОписаниеОповещения <> Неопределено);
	Если МассивЭД.Количество() > 0 Тогда
		МассивСлужебныхЭД = ОбменСКонтрагентамиСлужебныйВызовСервера.СформироватьСлужебныеЭД(МассивЭД, ВидЭД, ТекстУведомления);
		Если ЗначениеЗаполнено(МассивСлужебныхЭД) Тогда
			СтМассивовСтруктурСертификатов = Новый Структура;
			Действия = "ПодписатьОтправить";
			#Если Клиент Тогда
				ОбменСКонтрагентамиСлужебныйКлиент.ОбработатьЭД(Новый Массив,
					Действия, ДопПараметры, МассивСлужебныхЭД, ОписаниеОповещения);
				ВыполнитьОповещение = Ложь;
			#Иначе
				СтруктураСоответствий = Неопределено;
				СтСоотвСоглашенийИМассивовЭД = ОбменСКонтрагентамиСлужебныйВызовСервера.ВыполнитьДействияПоЭД(Новый Массив,
					Новый Массив, Действия, ДопПараметры, МассивСлужебныхЭД, СтруктураСоответствий);
			#КонецЕсли
		КонецЕсли;
	КонецЕсли;
	Если ВыполнитьОповещение И ТипЗнч(ОписаниеОповещения) = Тип("ОписаниеОповещения") Тогда
		#Если Клиент Тогда
			ВыполнитьОбработкуОповещения(ОписаниеОповещения);
		#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

// Заполнение состояния ЭДО.
//
// Параметры:
//  Форма					 - Форма - текущая форма.
//  ДокументСсылка			 - ДокументСсылка - ссылка на документ.
//  ДекорацияСостояниеЭДО	 - ЭлементФормы - элемент для надписи состояния.
//  ГруппаСостояниеЭДО		 - ГруппаЭлементыФормы - группа элементов ЭДО.
//
Процедура ЗаполнитьСостояниеЭДО(Форма, ДокументСсылка, ДекорацияСостояниеЭДО, ГруппаСостояниеЭДО = Неопределено) Экспорт
	
	ИспользоватьОбменЭД = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ЗначениеФункциональнойОпции("ИспользоватьОбменЭД");
	
	Если ГруппаСостояниеЭДО = Неопределено Тогда
		ДекорацияСостояниеЭДО.Видимость = ИспользоватьОбменЭД;
	Иначе
		ГруппаСостояниеЭДО.Видимость = ИспользоватьОбменЭД;
	КонецЕсли;
	
	Если Не ИспользоватьОбменЭД Тогда
		Возврат;
	КонецЕсли;
	
	ДекорацияДоступность = Истина;
	ТекстСостояния = ПолучитьТекстСостоянияЭД(ДокументСсылка, ДекорацияДоступность);
	
	Если ПустаяСтрока(ТекстСостояния) Тогда
		Если ГруппаСостояниеЭДО = Неопределено Тогда
			ДекорацияСостояниеЭДО.Видимость = Ложь;
		Иначе
			ГруппаСостояниеЭДО.Видимость = Ложь;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ДекорацияСостояниеЭДО.Заголовок = ТекстСостояния;
	ДекорацияСостояниеЭДО.Доступность = ДекорацияДоступность;
	
КонецПроцедуры

// Возвращает имя формы - ФормаСписка или ФормаЭлемента.
// 
// Параметры:
//  Форма - Форма - требуемая форма.
//
// Возвращаемое значение:
//  Строка - имя формы.
//
Функция КраткоеИмяФормы(Форма)  Экспорт
	
	Если ТипЗнч(Форма) = Тип("УправляемаяФорма") Тогда
		ИмяФормы = Форма.ИмяФормы;
	Иначе
		ИмяФормы = Форма;
	КонецЕсли;

	ЧастиИмени = СтрРазделить(ИмяФормы, ".");
	КраткоеИмяФормы = ЧастиИмени[ЧастиИмени.Количество()-1];
	
	Возврат КраткоеИмяФормы;

КонецФункции

#Область Тарификация

// Возвращает идентификатор услуги обмена электронными документами для осуществления тарификации.
// 
// Возвращаемое значение:
//  Строка - идентификатор услуги.
//
Функция ИдентификаторУслугиОбменаЭлектроннымиДокументами() Экспорт
	
	Возврат "1c-edo-access";
	
КонецФункции

#КонецОбласти

#КонецОбласти
