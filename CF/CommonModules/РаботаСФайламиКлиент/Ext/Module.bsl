﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с файлами".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Команды работы с файлами

// Открывает файл для просмотра или редактирования.
// Если файл открывается для просмотра, тогда получает файл в рабочий каталог пользователя,
// при этом ищет файл в рабочем каталоге и предлагает открыть существующий или получить файл с сервера.
// Если файл открывается для редактирования, тогда открывает файл в рабочем каталоге (если есть) или
// получает его с сервера.
//
// Параметры:
//  ДанныеФайла       - Структура - Данные файла. Описание см. РаботаСФайлами.ДанныеФайла.
//  ДляРедактирования - Булево - Истина, если файл открывается для редактирования, иначе Ложь.
//
Процедура ОткрытьФайл(Знач ДанныеФайла, Знач ДляРедактирования = Ложь) Экспорт
	
	Если ДляРедактирования Тогда
		РаботаСФайламиСлужебныйКлиент.РедактироватьФайл(Неопределено, ДанныеФайла);
	Иначе
		РаботаСФайламиСлужебныйКлиент.ОткрытьФайлСОповещением(Неопределено, ДанныеФайла, , ДляРедактирования); 
	КонецЕсли;
	
КонецПроцедуры

// Открывает в стандартной программе просмотра (проводнике) каталог на компьютере,
// в котором размещен указанный файл.
//
// Параметры:
//  ДанныеФайла - Структура - данные файла. Описание см. РаботаСФайлами.ДанныеФайла.
//
Процедура ОткрытьКаталогФайла(ДанныеФайла) Экспорт
	
	РаботаСФайламиСлужебныйКлиент.КаталогФайла(Неопределено, ДанныеФайла);
	
КонецПроцедуры

// Открывает диалог выбора файлов для помещения в программу одного или нескольких файлов.
// При этом проверяются необходимые условия:
// - размер файла не превышает максимально допустимый,
// - файл имеет допустимое расширение,
// - имеется свободное место в томе (при хранении файлов в томах),
// - прочие условия.
//
// Параметры:
//  ВладелецФайла      - ОпределяемыйТип.ВладелецПрисоединенныхФайлов - Папка файлов или объект, к которому
//                       требуется прикрепить добавляемый файл.
//  ИдентификаторФормы - УникальныйИдентификатор - Уникальный идентификатор формы, во временное хранилище
//                       которой будет помещен файл.
//  Фильтр             - Строка - Фильтр выбираемого файла, например, картинки для номенклатуры.
//  ГруппаФайлов       - ОпределяемыйТип.ПрисоединенныйФайл - Группа справочника с файлами, в которую будет 
//                       добавлен новый файл.
//
Процедура ДобавитьФайлы(Знач ВладелецФайла, Знач ИдентификаторФормы, Знач Фильтр = "", ГруппаФайлов = Неопределено) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ВладелецФайла",      ВладелецФайла);
	Параметры.Вставить("ИдентификаторФормы", ИдентификаторФормы);
	Параметры.Вставить("Фильтр",             Фильтр);
	Параметры.Вставить("ГруппаФайлов",       ГруппаФайлов);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьФайлыРасширениеПредложено", РаботаСФайламиСлужебныйКлиент, Параметры);
	РаботаСФайламиСлужебныйКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

// Открывает диалог выбора файлов для помещения в программу одного выбранного файла.
//
// Параметры:
//   ОбработчикРезультата - ОписаниеОповещения - Содержит описание процедуры, вызов которой будет произведен
//                                               после добавления файла со следующими параметрами:
//                    * Результат - Структура с полями:
//                       ** ФайлСсылка - ОпределяемыйТип.ПрисоединенныйФайл - Ссылка на элемент справочника с файлом,
//                                       если он был добавлен, иначе Неопределено.
//                       ** ФайлДобавлен - Булево - Истина, если файл добавлен.
//                       ** ТекстОшибки  - Строка - Текст ошибки, если файл не был добавлен.
//                    * ДополнительныеПараметры - значение, которое было указано при создании объекта оповещения.
//
//   ВладелецФайла - ОпределяемыйТип.ВладелецПрисоединенныхФайлов - Папка файлов или объект, к которому
//                       требуется прикрепить добавляемый файл.
//   ФормаВладелец - УправляемаяФорма - Форма, из которой вызвано создание файла.
//   РежимСоздания - Неопределено, Число - режим создания файла:
//       - Неопределено - Показать диалог выбора режима создания файла.
//       - Число - Создать файл указанным способом:
//           * 1 - из шаблона (копированием другого файла);
//           * 2 - с диска (из файловой системы клиента);
//           * 3 - со сканера.
//
//   НеОткрыватьКарточку - Булево - действие после создания:
//       * Ложь   - Открывать карточку файла после создания.
//       * Истина - Не открывать карточку файла после создания.
//
Процедура ДобавитьФайл(ОбработчикРезультата, ВладелецФайла, ФормаВладелец, РежимСоздания = Неопределено, 
	НеОткрыватьКарточку = Ложь) Экспорт
	
	Если РежимСоздания = Неопределено Тогда
		РаботаСФайламиСлужебныйКлиент.ДобавитьФайл(ОбработчикРезультата, ВладелецФайла, ФормаВладелец, , НеОткрыватьКарточку);
	Иначе
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("ОбработчикРезультата", ОбработчикРезультата);
		ПараметрыВыполнения.Вставить("ВладелецФайла", ВладелецФайла);
		ПараметрыВыполнения.Вставить("ФормаВладелец", ФормаВладелец);
		ПараметрыВыполнения.Вставить("НеОткрыватьКарточкуПослеСозданияИзФайла", НеОткрыватьКарточку);
		ПараметрыВыполнения.Вставить("ТолькоОдинФайл", Истина);
		РаботаСФайламиСлужебныйКлиент.ДобавитьПослеВыбораРежимаСоздания(РежимСоздания, ПараметрыВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму для настройки параметров рабочего каталога из персональных настроек пользователя программы.
// Рабочий каталог - папка на персональном компьютере пользователя, в которой временно хранятся файлы,
// полученные из программы для просмотра или редактирования.
//
Процедура ОткрытьФормуНастройкиРабочегоКаталога() Экспорт
	
	ОткрытьФорму("ОбщаяФорма.НастройкаРабочегоКаталога");
	
КонецПроцедуры

// Показать предупреждение перед закрытием формы объекта в том случае,
// если у пользователя остались захваченные файлы, присоединенные к этому объекту.
// Вызывается из события ПередЗакрытием форм с файлами.
//
// Если захваченные файлы остались, то в параметре Отказ устанавливается значение Истина,
// а пользователю задается вопрос. Если пользователь ответил утвердительно, то форма закрывается.
//
// Параметры:
//   Форма            - УправляемаяФорма - Форма, в которой редактируется файл.
//   Отказ            - Булево - Параметр события ПередЗакрытием.
//   ЗавершениеРаботы - Булево - Признак того, что форма закрывается в процессе завершения работы приложения.
//   ВладелецФайлов   - ОпределяемыйТип.ВладелецПрисоединенныхФайлов - Папка файлов или объект, к которому присоединены
//                                                                     файлы.
//   ИмяРеквизита     - Строка - Имя реквизита типа Булево, в котором хранится признак того,
//                               что вопрос уже выводился.
//
// Пример:
//
//	&НаКлиенте
//	Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
//		РаботаСФайламиКлиент.ПоказатьПодтверждениеЗакрытияФормыСФайлами(ЭтотОбъект, Отказ, ЗавершениеРаботы, Объект.Ссылка);
//	КонецПроцедуры
//
Процедура ПоказатьПодтверждениеЗакрытияФормыСФайлами(Форма, Отказ, ЗавершениеРаботы, ВладелецФайлов,
	ИмяРеквизита = "МожноЗакрытьФормуСФайлами") Экспорт
	
	ИмяПроцедуры = "РаботаСФайламиКлиент.ПоказатьПодтверждениеЗакрытияФормыСФайлами";
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "Форма", Форма, Тип("УправляемаяФорма"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "Отказ", Отказ, Тип("Булево"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "ЗавершениеРаботы", ЗавершениеРаботы, Тип("Булево"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "ИмяРеквизита", ИмяРеквизита, Тип("Строка"));
		
	Если Форма[ИмяРеквизита] Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Количество = РаботаСФайламиСлужебныйВызовСервера.КоличествоФайловЗанятыхТекущимПользователем(ВладелецФайлов);
	Если Количество = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ТекстВопроса = НСтр("ru = 'Один или несколько файлов заняты для редактирования.
	                          |
	                          |Продолжить?'");
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(Форма, Отказ, ЗавершениеРаботы, ТекстВопроса, ИмяРеквизита);
	
КонецПроцедуры

// Открывает форму нового файла с копией указанного файла.
//
// Параметры:
//  ВладелецФайла - ОпределяемыйТип.ВладелецПрисоединенныхФайлов - Папка файлов или объект, к которому присоединен файл.
//  ФайлОснование - ОпределяемыйТип.ПрисоединенныйФайл - Копируемый файл.
//  ДополнительныеПараметры - Структура - Параметры открытия формы.
//    * ИмяСправочникаХранилищаФайлов - Строка - Определяет справочник для хранения копии файла.
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - описание процедуры, которая будет вызвана при закрытии формы
//                                со следующими параметрами:
//                                <РезультатЗакрытия> - значение, переданное при вызове Закрыть() открываемой формы,
//                                <ДополнительныеПараметры> - значение, указанное при создании
//                                ОписаниеОповещенияОЗакрытии.
//                                Если параметр не указан, то по завершению никакая процедура вызвана не будет.
//
Процедура СкопироватьФайл(ВладелецФайла, ФайлОснование, ДополнительныеПараметры = Неопределено,
	ОписаниеОповещенияОЗакрытии = Неопределено) Экспорт
	
	ЭтоФайлы = ТипЗнч(ФайлОснование) = Тип("СправочникСсылка.Файлы");
	
	ПараметрыФормы = Новый Структура;
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
		ПараметрыФормы = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ДополнительныеПараметры);
		ИмяСправочникаХранилищаФайлов = Неопределено;
		Если ДополнительныеПараметры.Свойство("ИмяСправочникаХранилищаФайлов", ИмяСправочникаХранилищаФайлов) Тогда
			ЭтоФайлы = (ИмяСправочникаХранилищаФайлов = "Файлы");
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ЗначениеКопирования", ФайлОснование);
	ПараметрыФормы.Вставить("ВладелецФайла", ВладелецФайла);
	Если ЭтоФайлы Тогда
		ОткрытьФорму("Справочник.Файлы.ФормаОбъекта", ПараметрыФормы,,,,, ОписаниеОповещенияОЗакрытии);
	Иначе
		ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныйФайл", ПараметрыФормы,,,,, ОписаниеОповещенияОЗакрытии);
	КонецЕсли;
	
КонецПроцедуры

// Открывает список электронных подписей файла и предлагает выбрать подписи
// для сохранения вместе с файлом по выбранному пользователем пути.
// Имя файл подписи формируется из имени файла и автора подписи с расширением "p7s".
//
// При отсутствии в конфигурации подсистемы Электронная подпись сохранение файла не будет выполнено.
//
// Параметры:
//  ПрисоединенныйФайл - ОпределяемыйТип.ПрисоединенныйФайл - Ссылка на элемент справочника с файлом.
//  ИдентификаторФормы - УникальныйИдентификатор  - Уникальный идентификатор формы, который используется для блокировки файл.
//
Процедура СохранитьВместеСЭП(Знач ПрисоединенныйФайл, Знач ИдентификаторФормы) Экспорт
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляСохранения(ПрисоединенныйФайл);
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("ПрисоединенныйФайл", ПрисоединенныйФайл);
	ПараметрыВыполнения.Вставить("ДанныеФайла",        ДанныеФайла);
	ПараметрыВыполнения.Вставить("ИдентификаторФормы", ИдентификаторФормы);
	
	ОписаниеДанных = Новый Структура;
	ОписаниеДанных.Вставить("ЗаголовокДанных",     НСтр("ru = 'Файл'"));
	ОписаниеДанных.Вставить("ПоказатьКомментарий", Истина);
	ОписаниеДанных.Вставить("Представление",       ПараметрыВыполнения.ДанныеФайла.Ссылка);
	ОписаниеДанных.Вставить("Объект",              ПрисоединенныйФайл);
	
	ОписаниеДанных.Вставить("Данные",
		Новый ОписаниеОповещения("ПриСохраненииДанныхФайла", РаботаСФайламиСлужебныйКлиент, ПараметрыВыполнения));
	
	МодульЭлектроннаяПодписьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЭлектроннаяПодписьКлиент");
	МодульЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью(ОписаниеДанных);
	
КонецПроцедуры

// Открывает диалог сохранения файл, где пользователь может определить путь и имя для сохранения файла.
//
// Параметры:
//  ДанныеФайла - Структура - Данные файла. Описание см. РаботаСФайлами.ДанныеФайла.
//
Процедура СохранитьФайлКак(Знач ДанныеФайла) Экспорт
	
	РаботаСФайламиСлужебныйКлиент.СохранитьКак(Неопределено, ДанныеФайла, Неопределено);
	
КонецПроцедуры

// Открывает форму выбора файлов.
// Используется в обработчике выбора для переопределения стандартного поведения.
//
// Параметры:
//  ВладелецФайлов - ОпределяемыйТип.ВладелецПрисоединенныхФайлов - Папка файлов или объект,
//                   к которому прикреплены выбираемые файлы.
//  ЭлементФормы   - ТаблицаФормы, ПолеФормы - элемент формы, которому будет отправлено
//                   оповещение о выборе.
//  СтандартнаяОбработка - Булево - (возвращаемое значение), всегда устанавливается в Ложь.
//
Процедура ОткрытьФормуВыбораФайлов(Знач ВладелецФайлов, Знач ЭлементФормы, СтандартнаяОбработка = Ложь) Экспорт
	
	СтандартнаяОбработка = Ложь;

	Если ВладелецФайлов.Пустая() Тогда
		ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ВопросОНеобходимостиЗаписиПослеЗавершения", ЭтотОбъект);
		ПоказатьВопрос(ОбработчикОповещенияОЗакрытии,
			НСтр("ru = 'Данные еще не записаны. 
				|Переход к ""Присоединенные файлы"" возможен только после записи данных.'"),
				РежимДиалогаВопрос.ОК);
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ПараметрыФормы.Вставить("ВладелецФайла", ВладелецФайлов);
		ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы", ПараметрыФормы, ЭлементФормы);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму файла.
// Может использоваться как обработчик открытия файла.
//
// Параметры:
//  ПрисоединенныйФайл      - ОпределяемыйТип.ПрисоединенныйФайл - Ссылка на элемент справочника с файлом.
//  СтандартнаяОбработка    - Булево - (возвращаемое значение), всегда устанавливается в Ложь.
//  ДополнительныеПараметры - Структура - Параметры открытия формы.
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - описание процедуры, которая будет вызвана при закрытии формы 
//                                со следующими параметрами:
//                                <РезультатЗакрытия> - значение, переданное при вызове Закрыть() открываемой формы,
//                                <ДополнительныеПараметры> - значение, указанное при создании 
//                                ОписаниеОповещенияОЗакрытии. 
//                                Если параметр не указан, то по завершению никакая процедура вызвана не будет.
//
Процедура ОткрытьФормуФайла(Знач ПрисоединенныйФайл, СтандартнаяОбработка = Ложь, ДополнительныеПараметры = Неопределено, 
	ОписаниеОповещенияОЗакрытии = Неопределено) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ЗначениеЗаполнено(ПрисоединенныйФайл) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
		ПараметрыФормы = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ДополнительныеПараметры);
	КонецЕсли;	
	Если ТипЗнч(ПрисоединенныйФайл) = Тип("СправочникСсылка.Файлы") Тогда
		ПараметрыФормы.Вставить("Ключ", ПрисоединенныйФайл);
		ОткрытьФорму("Справочник.Файлы.ФормаОбъекта", ПараметрыФормы,,,,, ОписаниеОповещенияОЗакрытии);
	Иначе	
		ПараметрыФормы.Вставить("ПрисоединенныйФайл", ПрисоединенныйФайл);
		ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныйФайл", ПараметрыФормы,, ПрисоединенныйФайл,,, ОписаниеОповещенияОЗакрытии);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет печать файлов на принтер.
//
// Параметры:
//  Файлы              - ОпределяемыйТип.ПрисоединенныйФайл, Массив - Ссылка или массив ссылок на объекты с файлами.
//  ИдентификаторФормы - УникальныйИдентификатор - Уникальный идентификатор формы, во временное хранилище
//                       которой будет помещен файл.
//
Процедура НапечататьФайлы(Знач Файлы, ИдентификаторФормы = Неопределено) Экспорт
	
	Если ТипЗнч(Файлы) <> Тип("Массив") Тогда
		Файлы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Файлы);
	КонецЕсли;
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("НомерФайла",   0);
	ПараметрыВыполнения.Вставить("ДанныеФайлов", Файлы);
	ПараметрыВыполнения.Вставить("ДанныеФайла",  Файлы);
	ПараметрыВыполнения.Вставить("УникальныйИдентификатор", ИдентификаторФормы);
	НапечататьФайлыВыполнение(Неопределено, ПараметрыВыполнения);
	
КонецПроцедуры

// Выполняет подписание файла электронной подписью.
// При отсутствии подсистемы электронная подпись будет показано предупреждение
// о не возможности добавление электронной подписи.
//
// Параметры:
//  ПрисоединенныйФайл      - ОпределяемыйТип.ПрисоединенныйФайл - Ссылка на элемент справочника с файлом.
//  ИдентификаторФормы      - УникальныйИдентификатор - Уникальный идентификатор формы,
//                            который используется для блокировки файла.
//  ДополнительныеПараметры - Неопределено - стандартное поведение (см. ниже).
//                          - Структура - со свойствами:
//       * ДанныеФайла            - Структура - данные файла, если свойства нет, будет вставлено.
//       * ОбработкаРезультата    - ОписаниеОповещения - при вызове передается значение типа Булево,
//                                  если Истина - файл успешно подписан, иначе не подписан,
//                                  если свойства нет, оповещение не будет вызвано.
//
Процедура ПодписатьФайл(ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ПрисоединенныйФайл) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбран файл, который нужно подписать.'"));
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Добавление электронных подписей не поддерживается.'"));
		Возврат;
	КонецЕсли;
	
	МодульЭлектроннаяПодписьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЭлектроннаяПодписьКлиент");
	
	Если Не МодульЭлектроннаяПодписьКлиент.ИспользоватьЭлектронныеПодписи() Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Чтобы добавить электронную подпись, включите
			           |в настройках программы использование электронных подписей.'"));
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	Если Не ДополнительныеПараметры.Свойство("ДанныеФайла") Тогда
		ДополнительныеПараметры.Вставить("ДанныеФайла", РаботаСФайламиСлужебныйВызовСервера.ДанныеФайла(
			ПрисоединенныйФайл,, ИдентификаторФормы));
	КонецЕсли;
	
	ОбработкаРезультата = Неопределено;
	ДополнительныеПараметры.Свойство("ОбработкаРезультата", ОбработкаРезультата);
	
	РаботаСФайламиСлужебныйКлиент.ПодписатьФайл(ПрисоединенныйФайл,
		ДополнительныеПараметры.ДанныеФайла, ИдентификаторФормы, ОбработкаРезультата);
	
КонецПроцедуры

// См. РаботаСФайлами.ДанныеФайла.
// Возвращает структурированную информацию о файле. Используется в различных командах работы с файлами,
// и как значение параметра ДанныеФайла других процедур и функций.
//
Функция ДанныеФайла(Знач ФайлСсылка,
                    Знач ИдентификаторФормы = Неопределено,
                    Знач ПолучатьСсылкуНаДвоичныеДанные = Истина,
                    Знач ДляРедактирования = Ложь) Экспорт
	
	Возврат РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(
		ФайлСсылка,
		ИдентификаторФормы,
		ПолучатьСсылкуНаДвоичныеДанные,
		ДляРедактирования);

КонецФункции

// Получает файл из хранилища файлов в рабочий каталог пользователя.
// Аналог интерактивного действия Просмотреть или Редактировать без открытия полученного файла.
// Свойство ТолькоПросмотр полученного файла будет установлено в зависимости от того захвачен
// файл для редактирования или нет. Если не захвачен - устанавливается только просмотр.
// Если в рабочем каталоге уже существует файл, тогда он будет удален и заменен файлом,
// полученным из хранилища файлов.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - оповещение, которое выполняется после получения файла в
//   рабочий каталог пользователя. В качестве результата возвращается Структура со свойствами:
//     * ПолноеИмяФайла - Строка - полное имя файла (с путем).
//     * ОписаниеОшибки - Строка - текст ошибки, если получить файл не удалось.
//
//  ПрисоединенныйФайл - ОпределяемыйТип.ПрисоединенныйФайл - Ссылка на элемент справочник с файлом.
//  ИдентификаторФормы - УникальныйИдентификатор - Уникальный идентификатор формы, во временное хранилище
//                       которой будет помещен файл.
//
//  ДополнительныеПараметры - Неопределено - использовать значения по умолчанию.
//     - Структура - с необязательными свойствами:
//         * ДляРедактирования - Булево    - начальное значение Ложь. Если Истина,
//                                           тогда файл будет захвачен для редактирования.
//         * ДанныеФайла       - Структура - свойства файла, которые можно передать для ускорения
//                                           если они ранее были получены на клиент с сервера.
//
Процедура ПолучитьПрисоединенныйФайл(Оповещение, ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры = Неопределено) Экспорт
	
	РаботаСФайламиСлужебныйКлиент.ПолучитьПрисоединенныйФайл(Оповещение, ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры);
	
КонецПроцедуры

// Помещает файл из рабочего каталога пользователя в хранилище файлов.
// Аналог интерактивного действия Закончить редактирование.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - Оповещение, которое выполняется после помещения файла в
//   хранилище файлов. В качестве результата возвращается Структура со свойствами:
//     * ОписаниеОшибки - Строка - текст ошибки, если поместить файл не удалось.
//
//  ПрисоединенныйФайл - ОпределяемыйТип.ПрисоединенныйФайл - Ссылка на элемент справочника с файлом.
//  ИдентификаторФормы - УникальныйИдентификатор - Уникальный идентификатор формы,
//          во временное хранилище которой надо поместить данные и вернуть новый адрес.
//
//  ДополнительныеПараметры - Неопределено - использовать значения по умолчанию.
//     - Структура - с необязательными свойствами:
//         * ПолноеИмяФайла - Строка - если заполнено, то указанный файл будет помещен в рабочий каталог
//                                     пользователя, а затем в хранилище файлов.
//         * ДанныеФайла    - Структура - свойства файла, которые можно передать для ускорения
//                                        если они ранее были получены на клиент с сервера.
//
Процедура ПоместитьПрисоединенныйФайл(Оповещение, ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры = Неопределено) Экспорт
	
	РаботаСФайламиСлужебныйКлиент.ПоместитьПрисоединенныйФайл(Оповещение, ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа со сканером.

// Открывает форму настройки сканирования из пользовательских настроек.
//
Процедура ОткрытьФормуНастройкиСканирования() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Если СистемнаяИнформация.ТипПлатформы <> ТипПлатформы.Windows_x86
		Или ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
	 
		ТекстСообщения = НСтр("ru = 'Для сканирования необходимо использовать 32-битную версию программы  для ОС Windows.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	КомпонентаУстановлена = РаботаСФайламиСлужебныйКлиент.ПроинициализироватьКомпоненту();
	
	Если Не КомпонентаУстановлена Тогда
		ТекстВопроса = НСтр("ru = 'Для продолжения работы необходимо установить компоненту сканирования. 
		                          |Установить компоненту?'");
		Обработчик = Новый ОписаниеОповещения("ПоказатьВопросУстановкиКомпонентыСканирования", ЭтотОбъект, КомпонентаУстановлена);
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуНастройкиСканированияЗавершение(КомпонентаУстановлена, Неопределено);
	
КонецПроцедуры

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать РаботаСФайламиКлиент.ОткрытьФормуФайла
// Открывает форму файла из формы элемента справочника файлов. Форма элемента закрывается.
// 
// Параметры:
//  Форма     - УправляемаяФорма - Форма справочника присоединенных файлов.
//
Процедура ПерейтиКФормеФайла(Знач Форма) Экспорт
	
	ПрисоединенныйФайл = Форма.Ключ;
	
	Форма.Закрыть();
	
	Для Каждого ОкноКП Из ПолучитьОкна() Цикл
		
		Содержимое = ОкноКП.ПолучитьСодержимое();
		
		Если Содержимое = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Содержимое.ИмяФормы = "Обработка.РаботаСФайлами.Форма.ПрисоединенныйФайл" Тогда
			Если Содержимое.Параметры.Свойство("ПрисоединенныйФайл")
				И Содержимое.Параметры.ПрисоединенныйФайл = ПрисоединенныйФайл Тогда
				ОкноКП.Активизировать();
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ОткрытьФормуФайла(ПрисоединенныйФайл);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура предназначена для печати файла соответствующим приложением
//
// Параметры
//  ДанныеФайла          - Структура - данные файла. Описание см. РаботаСФайлами.ДанныеФайла.
//  ИмяОткрываемогоФайла - Строка - полное имя файла.
//
Процедура НапечататьФайлПриложением(ДанныеФайла, ИмяОткрываемогоФайла)
	
	РасширенияИсключения = 
	" m3u, m4a, mid, midi, mp2, mp3, mpa, rmi, wav, wma, 
	| 3g2, 3gp, 3gp2, 3gpp, asf, asx, avi, m1v, m2t, m2ts, m2v, m4v, mkv, mov, mp2v, mp4, mp4v, mpe, mpeg, mts, vob, wm, wmv, wmx, wvx,
	| 7z, zip, rar, arc, arh, arj, ark, p7m, pak, package, 
	| app, com, exe, jar, dll, res, iso, isz, mdf, mds,
	| cf, dt, epf, erf";
	
	Расширение = НРег(ДанныеФайла.Расширение);
	
	Если СтрНайти(РасширенияИсключения, " " + Расширение + ",") > 0 Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Печать файлов данного типа не поддерживается.'"), Расширение);
		ПоказатьПредупреждение(, ТекстСообщения);
		
		Возврат;
	
	ИначеЕсли Расширение = "grs" Тогда
		
		Схема = Новый ГрафическаяСхема;
		Схема.Прочитать(ИмяОткрываемогоФайла);
		Схема.Напечатать();;
		
	Иначе
		
		Попытка
			
			СистемнаяИнфо = Новый СистемнаяИнформация;
			Если СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86
				Или СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
				ИмяОткрываемогоФайла = СтрЗаменить(ИмяОткрываемогоФайла, "/", "\");
			КонецЕсли;
			
			НапечататьИзПриложенияПоИмениФайла(ИмяОткрываемогоФайла);
			
		Исключение
			
			Инфо = ИнформацияОбОшибке();
			ПоказатьПредупреждение(,СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Описание=""%1""'"),
				КраткоеПредставлениеОшибки(Инфо))); 
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура печати Файла
//
// Параметры:
//  ОбработчикРезультата - ОписаниеОповещения для дальнейшего вызова.
//  ПараметрыВыполнения  - Структура - со свойствами:
//        * НомерФайла               - Число - номер текущего файла,
//        * ДанныеФайла              - Структура - данные файла,
//        * УникальныйИдентификатор  - УникальныйИдентификатор.
//
Процедура НапечататьФайлыВыполнение(ОбработчикРезультата, ПараметрыВыполнения) Экспорт
	
	ОбработкаПрерыванияПользователя();
	
	Если ПараметрыВыполнения.НомерФайла >= ПараметрыВыполнения.ДанныеФайлов.Количество() Тогда
		Возврат;
	КонецЕсли;
	ПараметрыВыполнения.ДанныеФайла = 
		РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляПечати(ПараметрыВыполнения.ДанныеФайлов[ПараметрыВыполнения.НомерФайла],
		ПараметрыВыполнения.УникальныйИдентификатор);
		
#Если ВебКлиент Тогда
	Если ПараметрыВыполнения.ДанныеФайла.Расширение <> "mxl" Тогда
		Текст = НСтр("ru = 'Необходимо сохранить файл на компьютер, после чего выполнить
			|печать при помощи приложения, предназначенного
			|для работы с данным файлом.'");
		ПоказатьПредупреждение(, Текст);
		Возврат;
	КонецЕсли;
#КонецЕсли
	
	Если ПараметрыВыполнения.ДанныеФайла.Свойство("ТабличныйДокумент") Тогда
		ПараметрыВыполнения.ДанныеФайла.ТабличныйДокумент.Напечатать();
		// переходим к печати следующего файла.
		ПараметрыВыполнения.НомерФайла = ПараметрыВыполнения.НомерФайла + 1;
		Обработчик = Новый ОписаниеОповещения("НапечататьФайлыВыполнение", ЭтотОбъект, ПараметрыВыполнения);
		ВыполнитьОбработкуОповещения(Обработчик);
		Возврат
	КонецЕсли;
	
	Если РаботаСФайламиСлужебныйКлиент.РасширениеРаботыСФайламиПодключено() Тогда
		Обработчик = Новый ОписаниеОповещения("НапечататьФайлПослеПолученияВерсииВРабочийКаталог", ЭтотОбъект, ПараметрыВыполнения);
		РаботаСФайламиСлужебныйКлиент.ПолучитьФайлВерсииВРабочийКаталог(
			Обработчик,
			ПараметрыВыполнения.ДанныеФайла,
			"",
			ПараметрыВыполнения.УникальныйИдентификатор);
	Иначе
		ПараметрыВыполнения.ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ПараметрыВыполнения.ДанныеФайлов[ПараметрыВыполнения.НомерФайла], Неопределено);
		ОткрытьФайл(ПараметрыВыполнения.ДанныеФайла, Ложь);
	КонецЕсли;
КонецПроцедуры

// Процедура печати Файла после получения на диск
//
// Параметры:
//  ПараметрыВыполнения  - Структура - со свойствами:
//        * НомерФайла               - Число - номер текущего файла,
//        * ДанныеФайла              - Структура - данные файла,
//        * УникальныйИдентификатор  - УникальныйИдентификатор.
//
Процедура НапечататьФайлПослеПолученияВерсииВРабочийКаталог(Результат, ПараметрыВыполнения) Экспорт

	Если Результат.ФайлПолучен Тогда
		
		Если ПараметрыВыполнения.НомерФайла >= ПараметрыВыполнения.ДанныеФайлов.Количество() Тогда
			Возврат;
		КонецЕсли;
	
		НапечататьФайлПриложением(ПараметрыВыполнения.ДанныеФайла, Результат.ПолноеИмяФайла);
		
	КонецЕсли;

	// переходим к печати следующего файла.
	ПараметрыВыполнения.НомерФайла = ПараметрыВыполнения.НомерФайла + 1;
	Обработчик = Новый ОписаниеОповещения("НапечататьФайлыВыполнение", ЭтотОбъект, ПараметрыВыполнения);
	ВыполнитьОбработкуОповещения(Обработчик);
	
КонецПроцедуры

// Выполняет печать файла внешним приложением.
//
// Параметры
//  ИмяОткрываемогоФайла - Строка - полное имя файла.
//
Процедура НапечататьИзПриложенияПоИмениФайла(ИмяОткрываемогоФайла)
	
	Если Не ЗначениеЗаполнено(ИмяОткрываемогоФайла) Тогда
		Возврат;
	КонецЕсли;
		
	СистемнаяИнфо = Новый СистемнаяИнформация;
	Если СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 
	 Или СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		
		Shell = Новый COMОбъект("Shell.Application");
		Shell.ShellExecute(ИмяОткрываемогоФайла, "", "", "print", 1);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПоказатьВопросУстановкиКомпонентыСканирования(Результат, КомпонентаУстановлена) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Обработчик = Новый ОписаниеОповещения("ОткрытьФормуНастройкиСканированияЗавершение", ЭтотОбъект);
		РаботаСФайламиСлужебныйКлиент.УстановитьКомпоненту(Обработчик);
	КонецЕсли;
	
КонецФункции

Процедура ОткрытьФормуНастройкиСканированияЗавершение(КомпонентаУстановлена, ПараметрыВыполнения) Экспорт
	
	Если Не КомпонентаУстановлена Тогда
		Возврат;
	КонецЕсли;
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КомпонентаУстановлена", КомпонентаУстановлена);
	ПараметрыФормы.Вставить("ИдентификаторКлиента",  ИдентификаторКлиента);
	
	ОткрытьФорму("Обработка.Сканирование.Форма.НастройкаСканирования", ПараметрыФормы);
	
КонецПроцедуры

Процедура ВопросОНеобходимостиЗаписиПослеЗавершения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
