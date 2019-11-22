﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("НомерСтраницы", НомерСтраницы);
	Параметры.Свойство("ПалитраБыстрыхТоваров", ПалитраБыстрыхТоваров);
	
	ОбновитьФорму();
	
	Если Параметры.Свойство("ЗакрыватьБыстрыеТоварыПриВыбореТовара") Тогда
		ЭтотОбъект.ЗакрыватьПриВыборе = Параметры.ЗакрыватьБыстрыеТоварыПриВыбореТовара;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСтраницБыстрыеТоварыТовар(Команда)
	
	ИмяКоманды = Команда.Имя;
	НажатиеСтраница(ИмяКоманды)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаБыстрыеТоварыТовар(Команда)
	
	ИмяКоманды = Команда.Имя;
	ИмяКоманды = СтрЗаменить(ИмяКоманды, "ПрограммноКомандаБыстрыеТовары", "");
	
	НажатиеКнопка(ИмяКоманды);
	
КонецПроцедуры

&НаКлиенте
Процедура КартинкаСтраницБыстрыеТоварыШаблонНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	НажатиеСтраница(Элемент.Имя)
	
КонецПроцедуры

&НаКлиенте
Процедура КартинкаБыстрыеТоварыШаблонНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ИмяЭлемента = Элемент.Имя;
	ИмяЭлемента = СтрЗаменить(ИмяЭлемента, "Программно", "");
	
	НажатиеКнопка(ИмяЭлемента);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьФорму()
	
	// Быстрые товары
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПалитраБыстрыхТоваровБыстрыеТовары.Название КАК Название,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.ЭтоСтраница КАК ЭтоСтраница,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.НомерСтраницы КАК НомерСтраницы,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.СтраницаРазмещения КАК СтраницаРазмещения,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.ИмяКнопки КАК ИмяКнопки,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.Номенклатура КАК Номенклатура,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.Характеристика КАК Характеристика,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.ФайлКартинки КАК ФайлКартинки,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.Клавиша КАК Клавиша,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.АкселераторAlt КАК АкселераторAlt,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.АкселераторCtrl КАК АкселераторCtrl,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.АкселераторShift КАК АкселераторShift,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.Шрифт КАК Шрифт,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.Цвет КАК Цвет
	|ИЗ
	|	Справочник.ПалитраБыстрыхТоваров.БыстрыеТовары КАК ПалитраБыстрыхТоваровБыстрыеТовары
	|ГДЕ
	|	ПалитраБыстрыхТоваровБыстрыеТовары.Ссылка = &Ссылка
	|	И ПалитраБыстрыхТоваровБыстрыеТовары.СтраницаРазмещения <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания";
	
	Запрос.УстановитьПараметр("Ссылка", ПалитраБыстрыхТоваров);
	
	Результат = Запрос.Выполнить();
	ТаблицаЭлементовБыстрыхТоваров = Результат.Выгрузить();
	
	Элементы.СтраницаБыстрыхТоваровШаблон.Видимость   = Ложь;
	Элементы.СтраницаБыстрыхТоваровШаблон.Доступность = Ложь;
	
	// Шапка 
	МаксимальноеКоличествоКнопокВОдномРяду = ПалитраБыстрыхТоваров.МаксимальноеКоличествоКнопокВОдномРядуНаСтранице;
	
	МаксимальноеКоличествоРядов = МаксимальноеКоличествоРядов(МаксимальноеКоличествоКнопокВОдномРяду);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПалитраБыстрыхТоваровБыстрыеТовары.Название КАК Название,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.ЭтоСтраница КАК ЭтоСтраница,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.НомерСтраницы КАК НомерСтраницы,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.СтраницаРазмещения КАК СтраницаРазмещения,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.ИмяКнопки КАК ИмяКнопки,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.Номенклатура КАК Номенклатура,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.Характеристика КАК Характеристика,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.ФайлКартинки КАК ФайлКартинки,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.Клавиша КАК Клавиша,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.АкселераторAlt КАК АкселераторAlt,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.АкселераторCtrl КАК АкселераторCtrl,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.АкселераторShift КАК АкселераторShift,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.Шрифт КАК Шрифт,
	|	ПалитраБыстрыхТоваровБыстрыеТовары.Цвет КАК Цвет
	|ИЗ
	|	Справочник.ПалитраБыстрыхТоваров.БыстрыеТовары КАК ПалитраБыстрыхТоваровБыстрыеТовары
	|ГДЕ
	|	ПалитраБыстрыхТоваровБыстрыеТовары.Ссылка = &Ссылка
	|	И ПалитраБыстрыхТоваровБыстрыеТовары.СтраницаРазмещения = 0
	|	И ПалитраБыстрыхТоваровБыстрыеТовары.ЭтоСтраница
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтраницы";
	
	Запрос.УстановитьПараметр("Ссылка", ПалитраБыстрыхТоваров);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Элементы.ГруппаСтраницБыстрыхТоваровРядШаблон.Видимость   = Ложь;
	Элементы.ГруппаСтраницБыстрыхТоваровРядШаблон.Доступность = Ложь;
	
	КоличествоСтраницБыстрыхТоваров = Выборка.Количество();
	КоличествоРядовСтраниц = Цел(КоличествоСтраницБыстрыхТоваров/МаксимальноеКоличествоКнопокВОдномРяду);
	
	Если КоличествоСтраницБыстрыхТоваров < 2 Тогда
		
		Элементы.ГруппаСтраницБыстрыхТоваров.Доступность = Ложь;
		Элементы.ГруппаСтраницБыстрыхТоваров.Видимость   = Ложь;
		
	КонецЕсли;
	
	Если Не Цел(КоличествоСтраницБыстрыхТоваров / МаксимальноеКоличествоКнопокВОдномРяду) = (КоличествоСтраницБыстрыхТоваров / МаксимальноеКоличествоКнопокВОдномРяду) Тогда
		КоличествоРядовСтраниц = КоличествоРядовСтраниц + 1;
	КонецЕсли;
	
	Элементы.ГруппаСтраницБыстрыхТоваров.Высота = Элементы.ГруппаСтраницБыстрыхТоваровРядШаблон.Высота * КоличествоРядовСтраниц;
	
	// Создать группы 
	Для Ряд = 1 По КоличествоРядовСтраниц Цикл
		ИмяЭлемента = "ПрограммноГруппаСтраницБыстрыхТоваровРяд"+Формат(Ряд,"ЧГ=0");
		ЭлементРяд = Элементы.Вставить(ИмяЭлемента, Тип("ГруппаФормы"), Элементы.ГруппаСтраницБыстрыхТоваров);
		ЭлементРяд.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		ЗаполнитьЗначенияСвойств(ЭлементРяд, Элементы.ГруппаСтраницБыстрыхТоваровРядШаблон, , "Имя, Заголовок, ПутьКДаннымЗаголовка, Видимость, Доступность");
	КонецЦикла;
	
	// Заполнить кнопки и картинки.
	НомерСтрокиНастройкиСтраниц = 0;
	НомерСтрокиКартинокБыстрыхТоваров = 0;
	КартинкиБыстрыхТоваров.Очистить();
	КартинкиСтраницБыстрыхТоваров.Очистить();
	
	ПоследнийРяд = 0;
	
	Пока Выборка.Следующий() Цикл
		
		// Кнопка страницы
		СтрокаКартинкиСтраницБыстрыхТоваров = КартинкиСтраницБыстрыхТоваров.Добавить();
		
		ИмяКнопки = "КнопкаСтраницаБыстрыхТоваров" + Формат(Выборка.НомерСтраницы, "ЧН=0; ЧГ=0");
		НомерСтрокиНастройкиСтраниц = НомерСтрокиНастройкиСтраниц + 1;
		Ряд          = Цел((НомерСтрокиНастройкиСтраниц - 1) / МаксимальноеКоличествоКнопокВОдномРяду) + 1;
		ПозицияВРяду = НомерСтрокиНастройкиСтраниц - МаксимальноеКоличествоКнопокВОдномРяду * Цел((МаксимальноеКоличествоКнопокВОдномРяду * Ряд-1)/МаксимальноеКоличествоКнопокВОдномРяду);
		ЗаголовокКнопки = Выборка.Название;
		
		ГруппаРядаСтраниц = Элементы["ПрограммноГруппаСтраницБыстрыхТоваровРяд"+Формат(Ряд,"ЧГ=0")];
		
		// Создать кнопку или картинку.
		ЭтоКартинка = Ложь;
		ФайлКартинки = Выборка.ФайлКартинки;
		Если Не ФайлКартинки.Пустая() Тогда
			ДанныеФайла = НавигационнаяСсылкаКартинки(ФайлКартинки, УникальныйИдентификатор);
			ФайлХранилище = ПолучитьИзВременногоХранилища(ДанныеФайла);
			
			Если НЕ ФайлХранилище = Неопределено Тогда
				Если ТипЗнч(ФайлХранилище) = Тип("ДвоичныеДанные") Тогда
					ЭтоКартинка = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		СочетаниеКлавиш = Новый СочетаниеКлавиш(Клавиша[Выборка.Клавиша], Выборка.АкселераторAlt, Выборка.АкселераторCtrl, Выборка.АкселераторShift);
		ИмяКоманды = "ПрограммноКомандаСтраницаБыстрыеТовары" + ИмяКнопки;
		КомандаФормы = ЭтотОбъект.Команды.Добавить(ИмяКоманды);
		КомандаФормы.Действие = "КомандаСтраницБыстрыеТоварыТовар";
		
		ИмяЭлемента = "Программно" + ИмяКнопки;
		ЭлементПолеКартинка = Элементы.Вставить(ИмяЭлемента, Тип("ПолеФормы"),ГруппаРядаСтраниц);
		ЭлементПолеКартинка.Вид         = ВидПоляФормы.ПолеКартинки;
		
		ЭлементПолеКартинка.ПутьКДанным = "КартинкиСтраницБыстрыхТоваров[" + Формат(НомерСтрокиНастройкиСтраниц - 1, "ЧН=0; ЧГ=0") + "].АдресКартинки";
		Если ЭтоКартинка Тогда
			СтрокаКартинкиСтраницБыстрыхТоваров.АдресКартинки = ДанныеФайла;
		Иначе
			ЭлементПолеКартинка.ТекстНевыбраннойКартинки = ЗаголовокКнопки;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭлементПолеКартинка, Элементы.КартинкаСтраницБыстрыеТоварыШаблон,, "Имя, Заголовок, Видимость, Доступность, ПутьКДанным, ТекстНевыбраннойКартинки");
		
		ЭлементПолеКартинка.УстановитьДействие("Нажатие", "КартинкаСтраницБыстрыеТоварыШаблонНажатие");
		ЭлементПолеКартинка.СочетаниеКлавиш =  СочетаниеКлавиш;
		
		РозничныеПродажиСервер.ЗаполнитьШрифтЦвет(ЭлементПолеКартинка, Выборка.Шрифт, Выборка.Цвет); 
		
		СтрокаТаблицы = ТаблицаНомеровСтраниц.Добавить();
		СтрокаТаблицы.ИмяЭлемента = ИмяЭлемента;
		СтрокаТаблицы.НомерСтраницы = Выборка.НомерСтраницы;
		
		// акселератор кнопки страницы
		ИмяЭлемента = ИмяКоманды + "Акселераторы";
		ЭлементКнопка = Элементы.Вставить(ИмяЭлемента, Тип("КнопкаФормы"), Элементы.ГруппаПанельСтраницБыстрыхТоваров);
		ЭлементКнопка.Заголовок = ЗаголовокКнопки;
		
		Попытка
			ЭлементКнопка.ИмяКоманды = ИмяКоманды;
		Исключение
			Отказ = Истина;
			Возврат;
		КонецПопытки;
		
		ЭлементКнопка.СочетаниеКлавиш = СочетаниеКлавиш;
		
		СтрокаТаблицы = ТаблицаНомеровСтраниц.Добавить();
		СтрокаТаблицы.ИмяЭлемента = ИмяЭлемента;
		СтрокаТаблицы.НомерСтраницы = Выборка.НомерСтраницы;
		
		СтрокаТаблицы = ТаблицаНомеровСтраниц.Добавить();
		СтрокаТаблицы.ИмяЭлемента = ИмяКоманды;
		СтрокаТаблицы.НомерСтраницы = Выборка.НомерСтраницы;
		
		// Страница
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("СтраницаРазмещения", Выборка.НомерСтраницы);
		
		МассивСтрокБыстрыхТоваров = ТаблицаЭлементовБыстрыхТоваров.НайтиСтроки(СтруктураПоиска);
		
		ИмяЭлемента = "ПрограммноСтраницаБыстрыхТоваров" + Формат(Выборка.НомерСтраницы,"ЧГ=0");
		ЭлементСтраница = Элементы.Вставить(ИмяЭлемента, Тип("ГруппаФормы"), Элементы.СтраницыБыстрыхТоваров);
		ЭлементСтраница.Вид = ВидГруппыФормы.Страница;
		ЗаполнитьЗначенияСвойств(ЭлементСтраница, Элементы.СтраницаБыстрыхТоваровШаблон, , "Имя, Заголовок, ПутьКДаннымЗаголовка, Видимость, Доступность");
		ЭлементСтраница.Высота = Элементы.СтраницаБыстрыхТоваровШаблон.Высота * МаксимальноеКоличествоРядов;
		
		КоличествоБыстрыхТоваров = МассивСтрокБыстрыхТоваров.Количество();
		
		// Рассчитать высоту страницы
		КоличествоРядовКнопок = Цел(КоличествоБыстрыхТоваров/МаксимальноеКоличествоКнопокВОдномРяду);
		
		Если Не Цел(КоличествоБыстрыхТоваров / МаксимальноеКоличествоКнопокВОдномРяду) = (КоличествоБыстрыхТоваров / МаксимальноеКоличествоКнопокВОдномРяду) Тогда
			КоличествоРядовКнопок = КоличествоРядовКнопок + 1;
		КонецЕсли;
		
		// Создать группы 
		Для Ряд = 1 По КоличествоРядовКнопок + 1 Цикл
			ИмяЭлемента = "ПрограммноГруппаБыстрыхТоваровРяд" + Формат(Выборка.НомерСтраницы, "ЧН=0; ЧГ=0") + "_" + Формат(Ряд,"ЧГ=0");
			ЭлементРяд = Элементы.Вставить(ИмяЭлемента, Тип("ГруппаФормы"), ЭлементСтраница);
			ЭлементРяд.Вид = ВидГруппыФормы.ОбычнаяГруппа;
			ЗаполнитьЗначенияСвойств(ЭлементРяд, Элементы.ГруппаБыстрыхТоваровРядШаблон, , "Имя, Заголовок, ПутьКДаннымЗаголовка, Видимость, Доступность");
		КонецЦикла;
		
		НомерСтрокиНастройки = 0;
		
		Для каждого СтрокаБыстрыхТоваров Из МассивСтрокБыстрыхТоваров Цикл
			
			СтрокаКартинкиБыстрыхТоваров = КартинкиБыстрыхТоваров.Добавить();
			
			ИмяКнопки = "БыстрыйТовар" + Формат(Выборка.НомерСтраницы, "ЧН=0; ЧГ=0") + "_" + Формат(СтрокаБыстрыхТоваров.РеквизитДопУпорядочивания, "ЧН=0; ЧГ=0");
			НомерСтрокиНастройки = НомерСтрокиНастройки + 1;
			НомерСтрокиКартинокБыстрыхТоваров = НомерСтрокиКартинокБыстрыхТоваров + 1;
			Ряд          = Цел((НомерСтрокиНастройки - 1) / МаксимальноеКоличествоКнопокВОдномРяду) + 1;
			ПозицияВРяду = НомерСтрокиНастройки - МаксимальноеКоличествоКнопокВОдномРяду * Цел((МаксимальноеКоличествоКнопокВОдномРяду * Ряд-1)/МаксимальноеКоличествоКнопокВОдномРяду);
			ЗаголовокКнопки = СтрокаБыстрыхТоваров.Название;
			
			ГруппаРяда = Элементы["ПрограммноГруппаБыстрыхТоваровРяд" + Формат(Выборка.НомерСтраницы, "ЧН=0; ЧГ=0") + "_" + Формат(Ряд,"ЧГ=0")];
			
			// Создать кнопку или картинку.
			ЭтоКартинка = Ложь;
			ФайлКартинки = СтрокаБыстрыхТоваров.ФайлКартинки;
			Если Не ФайлКартинки.Пустая() Тогда
				ДанныеФайла = НавигационнаяСсылкаКартинки(ФайлКартинки, УникальныйИдентификатор);
				ФайлХранилище = ПолучитьИзВременногоХранилища(ДанныеФайла);
				
				Если НЕ ФайлХранилище = Неопределено Тогда
					Если ТипЗнч(ФайлХранилище) = Тип("ДвоичныеДанные") Тогда
						ЭтоКартинка = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			СочетаниеКлавиш = Новый СочетаниеКлавиш(Клавиша[СтрокаБыстрыхТоваров.Клавиша], СтрокаБыстрыхТоваров.АкселераторAlt, СтрокаБыстрыхТоваров.АкселераторCtrl, СтрокаБыстрыхТоваров.АкселераторShift);
			
			ИмяКоманды = "ПрограммноКомандаБыстрыеТовары" + ИмяКнопки;
			КомандаФормы = ЭтотОбъект.Команды.Добавить(ИмяКоманды);
			КомандаФормы.Действие = "КомандаБыстрыеТоварыТовар";
			
			ИмяЭлемента = "Программно" + ИмяКнопки;
			ЭлементПолеКартинка = Элементы.Вставить(ИмяЭлемента, Тип("ПолеФормы"),ГруппаРяда);
			ЭлементПолеКартинка.Вид = ВидПоляФормы.ПолеКартинки;
			
			ЭлементПолеКартинка.ПутьКДанным = "КартинкиБыстрыхТоваров[" + Формат(НомерСтрокиКартинокБыстрыхТоваров - 1, "ЧН=0; ЧГ=0") + "].АдресКартинки";
			Если ЭтоКартинка Тогда
				СтрокаКартинкиБыстрыхТоваров.АдресКартинки = ДанныеФайла;
			Иначе
				ЭлементПолеКартинка.ТекстНевыбраннойКартинки = ЗаголовокКнопки;
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(ЭлементПолеКартинка, Элементы.КартинкаБыстрыеТоварыШаблон,, "Имя, Заголовок, Видимость, Доступность, ПутьКДанным, ТекстНевыбраннойКартинки");
			
			ЭлементПолеКартинка.УстановитьДействие("Нажатие", "КартинкаБыстрыеТоварыШаблонНажатие");
			ЭлементПолеКартинка.СочетаниеКлавиш =  СочетаниеКлавиш;
			
			РозничныеПродажиСервер.ЗаполнитьШрифтЦвет(ЭлементПолеКартинка, СтрокаБыстрыхТоваров.Шрифт, СтрокаБыстрыхТоваров.Цвет); 
			
			ИмяЭлемента = ИмяКоманды + "Акселераторы";
			ЭлементКнопка = Элементы.Вставить(ИмяЭлемента, Тип("КнопкаФормы"), Элементы.ГруппаПанельБыстрыхТоваров);
			ЭлементКнопка.Заголовок = ЗаголовокКнопки;
			
			Попытка
				ЭлементКнопка.ИмяКоманды = ИмяКоманды;
			Исключение
				Отказ = Истина;
				Возврат;
			КонецПопытки;
			
			ЭлементКнопка.СочетаниеКлавиш = СочетаниеКлавиш;
			
			СтрокаТаблицыБыстрыхТоваров = ТаблицаБыстрыхТоваров.Добавить();
			СтрокаТаблицыБыстрыхТоваров.ИдентификаторБыстрогоТовара = ИмяКнопки;
			СтрокаТаблицыБыстрыхТоваров.Номенклатура                = СтрокаБыстрыхТоваров.Номенклатура;
			СтрокаТаблицыБыстрыхТоваров.Характеристика              = СтрокаБыстрыхТоваров.Характеристика;
			
		КонецЦикла;
		
		
		// До заполнение пустой картинкой.
		Если КоличествоРядовКнопок > 1 Тогда
			ВыводимыйОстаток = КоличествоРядовКнопок * МаксимальноеКоличествоКнопокВОдномРяду - КоличествоБыстрыхТоваров;
			
			Для Индекс = 1 По ВыводимыйОстаток Цикл
				ИмяЭлемента = "ПрограммноПустаяКартинкаБыстрыхТоваров" + Формат(Выборка.НомерСтраницы, "ЧН=0; ЧГ=0") + "_" + Формат(Индекс,"ЧГ=0");
				ЭлементПолеКартинка = Элементы.Вставить(ИмяЭлемента, Тип("ПолеФормы"),ГруппаРяда);
				ЭлементПолеКартинка.ПутьКДанным = "КартинкаШаблон";
				ЭлементПолеКартинка.Вид         = ВидПоляФормы.ПолеКартинки;
				ЗаполнитьЗначенияСвойств(ЭлементПолеКартинка, Элементы.КартинкаСтраницПустаяБыстрыеТоварыШаблон,, "Имя, Заголовок, Видимость, ПутьКДанным, ТекстНевыбраннойКартинки");
			КонецЦикла;
		КонецЕсли;
		
		ПоследнийРяд = Выборка.НомерСтраницы;
	КонецЦикла;
	
	// До заполнение пустой картинкой.
	Если КоличествоРядовСтраниц > 1 Тогда
		ПоследнийРяд = ПоследнийРяд + 1;
		ВыводимыйОстаток = КоличествоРядовСтраниц * МаксимальноеКоличествоКнопокВОдномРяду - КоличествоСтраницБыстрыхТоваров;
		
		Для Индекс = 1 По ВыводимыйОстаток Цикл
			ИмяЭлемента = "ПрограммноПустаяКартинкаБыстрыхТоваров" + Формат(ПоследнийРяд, "ЧН=0; ЧГ=0") + "_" + Формат(Индекс,"ЧГ=0");
			ЭлементПолеКартинка = Элементы.Вставить(ИмяЭлемента, Тип("ПолеФормы"), ГруппаРядаСтраниц);
			ЭлементПолеКартинка.ПутьКДанным = "КартинкаШаблон";
			ЭлементПолеКартинка.Вид         = ВидПоляФормы.ПолеКартинки;
			ЗаполнитьЗначенияСвойств(ЭлементПолеКартинка, Элементы.КартинкаПустаяБыстрыеТоварыШаблон,, "Имя, Заголовок, Видимость, ПутьКДанным, ТекстНевыбраннойКартинки");
		КонецЦикла;
	КонецЕсли;
	
	УстановитьТекущуюСтраницу(НомерСтраницы);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НавигационнаяСсылкаКартинки(ФайлКартинки, ИдентификаторФормы)

	УстановитьПривилегированныйРежим(Истина);

	Возврат РаботаСФайлами.ДанныеФайла(ФайлКартинки, ИдентификаторФормы).СсылкаНаДвоичныеДанныеФайла;

КонецФункции

&НаКлиенте
Процедура НажатиеКнопка(ИдентификаторБыстрогоТовара)
	
	МассивСтрок = ТаблицаБыстрыхТоваров.НайтиСтроки(Новый Структура("ИдентификаторБыстрогоТовара", ИдентификаторБыстрогоТовара));
	
	Если МассивСтрок.Количество() > 0 Тогда
		
		СтрокаБыстрыхТоваров = МассивСтрок[0];
		
		ВыбранноеЗначение = Новый Структура("Номенклатура, Характеристика");
		ЗаполнитьЗначенияСвойств(ВыбранноеЗначение, СтрокаБыстрыхТоваров);
		ВыбранноеЗначение.Вставить("ИмяДействия", НСтр("ru = 'Подбор быстрого товара'"));
		ВыбранноеЗначение.Вставить("Упаковка"      , ПредопределенноеЗначение("Справочник.УпаковкиНоменклатуры.ПустаяСсылка"));
		
		ОповеститьОВыборе(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция МаксимальноеКоличествоРядов(МаксимальноеКоличествоКнопокВОдномРяду)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПалитраБыстрыхТоваровБыстрыеТовары.НомерСтраницы,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПалитраБыстрыхТоваровБыстрыеТовары.НомерСтроки) КАК КоличествоЭлементов
	|ПОМЕСТИТЬ ТаблицаКоличествоЭлементов
	|ИЗ
	|	Справочник.ПалитраБыстрыхТоваров.БыстрыеТовары КАК ПалитраБыстрыхТоваровБыстрыеТовары
	|ГДЕ
	|	ПалитраБыстрыхТоваровБыстрыеТовары.Ссылка = &Ссылка
	|	И ПалитраБыстрыхТоваровБыстрыеТовары.ЭтоСтраница <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ПалитраБыстрыхТоваровБыстрыеТовары.НомерСтраницы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ТаблицаКоличествоЭлементов.НомерСтраницы,
	|	ТаблицаКоличествоЭлементов.КоличествоЭлементов КАК КоличествоЭлементов
	|ИЗ
	|	ТаблицаКоличествоЭлементов КАК ТаблицаКоличествоЭлементов
	|
	|УПОРЯДОЧИТЬ ПО
	|	КоличествоЭлементов УБЫВ";
	
	Запрос.УстановитьПараметр("Ссылка", ПалитраБыстрыхТоваров);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		КоличествоБыстрыхТоваров = Выборка.КоличествоЭлементов
	Иначе
		КоличествоБыстрыхТоваров = 1
	КонецЕсли;
	
	КоличествоРядовКнопок = Цел(КоличествоБыстрыхТоваров/МаксимальноеКоличествоКнопокВОдномРяду);
	
	Если Не Цел(КоличествоБыстрыхТоваров / МаксимальноеКоличествоКнопокВОдномРяду) = (КоличествоБыстрыхТоваров / МаксимальноеКоличествоКнопокВОдномРяду) Тогда
		КоличествоРядовКнопок = КоличествоРядовКнопок + 1;
	КонецЕсли;
	
	Возврат КоличествоРядовКнопок;
	
КонецФункции

&НаСервере
Процедура УстановитьТекущуюСтраницу(НомерТекущейСтраницы)
	
	ОграничениеЗаполнения = "Имя, Заголовок, Видимость, Доступность, ПутьКДанным, ТекстНевыбраннойКартинки";
	Для каждого ПодчиненныйЭлементРяд Из Элементы.ГруппаСтраницБыстрыхТоваров.ПодчиненныеЭлементы Цикл
		Если НЕ ПодчиненныйЭлементРяд = Элементы.ГруппаСтраницБыстрыхТоваровРядШаблон Тогда
			Для каждого ПодчиненныйЭлемент Из ПодчиненныйЭлементРяд.ПодчиненныеЭлементы Цикл
				ИмяЭлемента = ПодчиненныйЭлемент.Имя;
				Если Найти(ИмяЭлемента, "ПрограммноПустаяКартинкаБыстрыхТоваров") = 0 Тогда
					ЗаполнитьЗначенияСвойств(ПодчиненныйЭлемент, Элементы.КартинкаСтраницБыстрыеТоварыШаблон,, ОграничениеЗаполнения);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	ЭлементКнопкаСтраница = Элементы.Найти("ПрограммноКнопкаСтраницаБыстрыхТоваров" + Формат(НомерТекущейСтраницы, "ЧН=0; ЧГ=0"));
	ЗаполнитьЗначенияСвойств(ЭлементКнопкаСтраница, Элементы.ВыделеннаяКартинкаСтраницБыстрыеТоварыШаблон,, ОграничениеЗаполнения);
	
	Элементы.ДекорацияЗаголовок.Заголовок = ЭлементКнопкаСтраница.ТекстНевыбраннойКартинки;
	
	ЭлементСтраница = Элементы.Найти("ПрограммноСтраницаБыстрыхТоваров" + Формат(НомерТекущейСтраницы,"ЧГ=0"));
	Элементы.СтраницыБыстрыхТоваров.ТекущаяСтраница = ЭлементСтраница;
	
	НомерСтраницы = НомерТекущейСтраницы;
КонецПроцедуры

&НаСервере
Процедура НажатиеСтраница(ИмяЭлемента)
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("ИмяЭлемента",ИмяЭлемента);
	
	МассивСтрок = ТаблицаНомеровСтраниц.НайтиСтроки(СтруктураПоиска);
	НомерТекущейСтраницы = МассивСтрок[0].НомерСтраницы;
	
	Если НЕ НомерТекущейСтраницы = НомерСтраницы Тогда
		УстановитьТекущуюСтраницу(НомерТекущейСтраницы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
