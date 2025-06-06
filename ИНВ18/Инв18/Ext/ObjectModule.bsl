﻿Перем мВалютаРегламентированногоУчета;
Перем мВалютаУпрУчета;

Функция СведенияОВнешнейОбработке() Экспорт     
	
	ПараметрыРегистрации = Новый Структура;
	МассивНазначений = Новый Массив;
	МассивНазначений.Добавить("Документ.ИнвентаризацияОС");
	ПараметрыРегистрации.Вставить("Вид", "ПечатнаяФорма"); 
	ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
	ПараметрыРегистрации.Вставить("Наименование", "ИНВ-18");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", ЛОЖЬ);
	ПараметрыРегистрации.Вставить("Версия", "1.0"); 
	ПараметрыРегистрации.Вставить("Информация", ""); 
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	ДобавитьКоманду(ТаблицаКоманд, "ИНВ-18 с графами 12-17", "ИНВ18", "открытиеФормы", Истина, "ПечатьMXL");
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Функция ПолучитьТаблицуКоманд() 
	
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	Возврат Команды; 
	
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление; 
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	
КонецПроцедуры

Функция Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СсылкаНаОбъект = МассивОбъектов[0];
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИнвентаризацияОС_ИНВ18";
	НомерСтраницы   = 2;
	ПечатьИНВ18(СсылкаНаОбъект,	ОбъектыПечати, ПараметрыВывода);
	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,"ИНВ18","ИНВ18",ТабДокумент);

КонецФункции         

Функция ОтладкаПечати(Ссылка) Экспорт
	Возврат(ПечатьИНВ18(ссылка, Неопределено, неопределено)); 	
КонецФункции	

Функция ПечатьИНВ18(СсылкаНаОбъект, ОбъектыПечати, ПараметрыПечати)
	
	ТабДокумент = Новый ТабличныйДокумент;
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИнвентаризацияОС.Дата КАК Дата,
	|	ИнвентаризацияОС.Номер КАК Номер,
	|	ИнвентаризацияОС.Организация КАК Организация,
	|	ИнвентаризацияОС.ПодразделениеОрганизации.Представление КАК ПодразделениеПредставление,
	|	ИнвентаризацияОС.ПодразделениеОрганизации.Код КАК ПодразделениеКод,
	|	ИнвентаризацияОС.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	|	ИнвентаризацияОС.ДатаНачалаИнвентаризации КАК ДатаНачалаИнвентаризации,
	|	ИнвентаризацияОС.ДатаОкончанияИнвентаризации КАК ДатаОкончанияИнвентаризации,
	|	ИнвентаризацияОС.ДокументОснованиеВид КАК ДокументОснованиеВид,
	|	ИнвентаризацияОС.ДокументОснованиеДата КАК ДокументОснованиеДата,
	|	ИнвентаризацияОС.ДокументОснованиеНомер КАК ДокументОснованиеНомер,
	|	ИнвентаризацияОС.ОтветственноеЛицо как мол,
	|	ИнвентаризацияОС.игс_Склад КАК Склад
	|ИЗ
	|	Документ.ИнвентаризацияОС КАК ИнвентаризацияОС
	|ГДЕ
	|	ИнвентаризацияОС.Ссылка = &Ссылка";
	
	Док = Запрос.Выполнить().Выбрать();
	Док.Следующий();
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);
	ДанныеИнвентаризации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СсылкаНаОбъект,"ДатаОкончанияИнвентаризации,ДатаНачалаИнвентаризации,Организация",Истина);  
	Запрос.УстановитьПараметр("КонецПериодаДата", ДанныеИнвентаризации.ДатаОкончанияИнвентаризации);
	Запрос.УстановитьПараметр("НачалоПериода", ДанныеИнвентаризации.ДатаНачалаИнвентаризации); 
	Запрос.УстановитьПараметр("Организация", ДанныеИнвентаризации.Организация);
    Запрос.УстановитьПараметр("СубконтоОсновноеСредство", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства);
		СписокСчетов = Новый Массив();
	СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.ОсновныеСредства);
	СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.НайтиПоКоду("001"));
	СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.НайтиПоКоду("03"));
	СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.НайтиПоКоду("МЦ.08"));
    Запрос.УстановитьПараметр("СписокСчетов", СписокСчетов);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИнвентаризацияОСОС.НомерСтроки КАК НомерСтроки,
	|	ИнвентаризацияОСОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ВЫБОР
	|		КОГДА ИнвентаризацияОСОС.ОсновноеСредство.НаименованиеПолное ПОДОБНО """"
	|			ТОГДА ИнвентаризацияОСОС.ОсновноеСредство.Наименование
	|		ИНАЧЕ ИнвентаризацияОСОС.ОсновноеСредство.НаименованиеПолное
	|	КОНЕЦ КАК ОсновноеСредствоНаименованиеПолное,
	|	ИнвентаризацияОСОС.ОсновноеСредство.ДатаВыпуска КАК ДатаВыпуска,
	|	ИнвентаризацияОСОС.ОсновноеСредство.ЗаводскойНомер КАК ЗаводскойНомер,
	|	ЕСТЬNULL(ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ИнвентарныйНомер, ИнвентаризацияОСОС.ОсновноеСредство.Код) КАК ИнвентарныйНомер,
	|	ИнвентаризацияОСОС.ОсновноеСредство.НомерПаспорта КАК НомерПаспорта,
	|	ИнвентаризацияОСОС.СтоимостьПоДаннымУчета КАК СтоимостьПоДаннымУчета,
	|	ИнвентаризацияОСОС.СтоимостьФактическая КАК СтоимостьФактическая,
	|	ИнвентаризацияОСОС.КоличествоПоДаннымУчета КАК НаличиеПоДаннымУчета,
	|	ИнвентаризацияОСОС.КоличествоФактическое КАК НаличиеФактическое
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	Документ.ИнвентаризацияОС.ОС КАК ИнвентаризацияОСОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(
	|				,
	|				Организация = &Организация
	|					И ОсновноеСредство В
	|						(ВЫБРАТЬ
	|							ИнвентаризацияОСОС.ОсновноеСредство
	|						ИЗ
	|							Документ.ИнвентаризацияОС.ОС КАК ИнвентаризацияОСОС
	|						ГДЕ
	|							ИнвентаризацияОСОС.Ссылка = &Ссылка)) КАК ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних
	|		ПО ИнвентаризацияОСОС.ОсновноеСредство = ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
	|ГДЕ
	|	ИнвентаризацияОСОС.Ссылка = &Ссылка
	|	И ИнвентаризацияОСОС.КоличествоПоДаннымУчета <> ИнвентаризацияОСОС.КоличествоФактическое
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.ОсновноеСредство КАК ОсновноеСредство,
	|	Товары.ОсновноеСредствоНаименованиеПолное КАК ОсновноеСредствоНаименованиеПолное,
	|	Товары.ДатаВыпуска КАК ДатаВыпуска,
	|	Товары.ЗаводскойНомер КАК ЗаводскойНомер,
	|	Товары.ИнвентарныйНомер КАК ИнвентарныйНомер,
	|	Товары.НомерПаспорта КАК НомерПаспорта,
	|	Товары.СтоимостьПоДаннымУчета КАК СтоимостьПоДаннымУчета,
	|	Товары.СтоимостьФактическая КАК СтоимостьФактическая,
	|	Товары.НаличиеПоДаннымУчета КАК НаличиеПоДаннымУчета,
	|	Товары.НаличиеФактическое КАК НаличиеФактическое
	|ИЗ
	|	Товары КАК Товары
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	ВЫБОР
	|		КОГДА ХозрасчетныйОбороты.СуммаОборотДт > 0
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РегулировкаИзлишекКолво,
	|	ВЫБОР
	|		КОГДА ХозрасчетныйОбороты.СуммаОборотДт > 0
	|			ТОГДА ХозрасчетныйОбороты.СуммаОборотДт
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РегулировкаИзлишекСумма,
	|	ВЫБОР
	|		КОГДА ХозрасчетныйОбороты.СуммаОборотКт > 0
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РегулировкаНедостачаКолво,
	|	ВЫБОР
	|		КОГДА ХозрасчетныйОбороты.СуммаОборотКт > 0
	|			ТОГДА ХозрасчетныйОбороты.СуммаОборотКт
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РегулировкаНедостачаСумма,
	|	ХозрасчетныйОбороты.Регистратор КАК Регистратор,
	|	ХозрасчетныйОбороты.Субконто1 КАК ОсновноеСредство
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(
	|			&НачалоПериода,
	|			,
	|			Регистратор,
	|			Счет В ИЕРАРХИИ (&СписокСчетов),
	|			&СубконтоОсновноеСредство,
	|			Субконто1 В
	|				(ВЫБРАТЬ
	|					Товары.ОсновноеСредство
	|				ИЗ
	|					Товары КАК Товары),
	|			,
	|			) КАК ХозрасчетныйОбороты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Товары КАК Товары
	|		ПО ХозрасчетныйОбороты.Субконто1 = Товары.ОсновноеСредство
	|ГДЕ
	|	ХозрасчетныйОбороты.Период МЕЖДУ &НачалоПериода И &КонецПериодаДата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ  Товары";
	
	Пакет 				= Запрос.ВыполнитьПакет();
	ТаблицаОС 			= Пакет[1].Выгрузить();
	ТаблицаДокументов	= Пакет[2].Выгрузить();
	
	
	Макет = ПолучитьМакет("ИНВ18");
	
	// Получаем области макета для вывода в табличный документ
	Шапка                     = Макет.ПолучитьОбласть("Шапка");
	СекцияМОЛ                 = Макет.ПолучитьОбласть("СекцияМОЛ");
	СтрокаНадТаблицей         = Макет.ПолучитьОбласть("СтрокаНадТаблицей");
	ЗаголовокТаблицы          = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	СтрокаТаблицы             = Макет.ПолучитьОбласть("СтрокаТаблицы");
	ПодвалТаблицы             = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ПодписьГлавногоБухгалтера = Макет.ПолучитьОбласть("ПодписьГлавногоБухгалтера");
	ШапкаПодписейМОЛ          = Макет.ПолучитьОбласть("ШапкаПодписейМОЛ");
	Подпись                   = Макет.ПолучитьОбласть("Подпись");
	
	// Зададим параметры макета по умолчанию
	ТабДокумент.ПолеСверху              = 10;
	ТабДокумент.ПолеСлева               = 0;
	ТабДокумент.ПолеСнизу               = 0;
	ТабДокумент.ПолеСправа              = 0;
	ТабДокумент.РазмерКолонтитулаСверху = 10;
	ТабДокумент.ОриентацияСтраницы      = ОриентацияСтраницы.Ландшафт;
	
	// Загрузим настройки пользователя
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИнвентаризацияОС_ИНВ18";

	// Выведем шапку документа
	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Док.Организация, Док.Дата);
	
	Шапка.Параметры.Заполнить(Док);
	Шапка.Параметры.Организация          = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации);
	Шапка.Параметры.ОрганизацияКодПоОКПО = СведенияОбОрганизации.КодПоОКПО;
	Шапка.Параметры.Подразделение        = Док.ПодразделениеПредставление;
	
	Если ЗначениеЗаполнено(Док.Склад) Тогда
		Шапка.Параметры.Подразделение		 = Док.Склад;
	КонецЕсли;
	
	Шапка.Параметры.ДатаДокумента  = Док.Дата;
	
	ТабДокумент.Вывести(Шапка);
	
	// Получим список МОЛ на основании списка ОС
	СписокОС = ТаблицаОС.ВыгрузитьКолонку("ОсновноеСредство");
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ОсновноеСредство", СписокОС);
	Запрос.УстановитьПараметр("Организация",      СсылкаНаОбъект.Организация);
	Запрос.УстановитьПараметр("Дата",             СсылкаНаОбъект.Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.МОЛ КАК МОЛ
	|ИЗ
	|	РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
	|			&Дата,
	|			Организация = &Организация
	|				И ОсновноеСредство В (&ОсновноеСредство)) КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних";
	
	Результат = Запрос.Выполнить().Выгрузить();
	СписокМОЛ = Результат.ВыгрузитьКолонку("МОЛ");
	
	// Проверим, помещаются ли строка над таблицей, заголовок и первая строка.
	ШапкаТаблицы = Новый Массив;
	ШапкаТаблицы.Добавить(СтрокаНадТаблицей);
	ШапкаТаблицы.Добавить(ЗаголовокТаблицы);
	ШапкаТаблицы.Добавить(СтрокаТаблицы);
	
	Если НЕ ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабДокумент, ШапкаТаблицы) Тогда
			
		// Выведем разрыв страницы
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();

	КонецЕсли;
	
	// Выведем строку над таблицей
	ТабДокумент.Вывести(СтрокаНадТаблицей);
	
	// Выведем заголовок таблицы	
	ТабДокумент.Вывести(ЗаголовокТаблицы);
	
	// Создадим переменные для накопления итогов по каждой странице
	ИтогИзлишекКоличество   = 0;
	ИтогИзлишекСтоимость    = 0;
	ИтогНедостачаКоличество = 0;
	ИтогНедостачаСтоимость  = 0;
	
	// ИГС ИД Компания, Мостовых Д.В. 20.11.2017 {
	ИтогоРегулировкаИзлишекКолво = 0;
	ИтогоРегулировкаИзлишекСумма = 0;
	ИтогоРегулировкаНедостачаКолво = 0;
	ИтогоРегулировкаНедостачаСумма = 0;
	ИтогоРегулировкаИзлишекКолво1 = 0;
	ИтогоРегулировкаИзлишекСумма1 = 0;
	ИтогоРегулировкаНедостачаКолво1 = 0;
	ИтогоРегулировкаНедостачаСумма1 = 0;
	// } ИГС ИД Компания, Мостовых Д.В. 
	
	// Выведем строки таблицы
	Для Каждого СтрокаОС Из ТаблицаОС Цикл
		
		СтрокаТаблицы.Параметры.Заполнить(СтрокаОС);
		
		СтрокаСПодвалом = Новый Массив;
		СтрокаСПодвалом.Добавить(СтрокаТаблицы);
		СтрокаСПодвалом.Добавить(ПодвалТаблицы);
		Если (ТаблицаОС.Индекс(СтрокаОС) + 1) = ТаблицаОС.Количество() Тогда // если последняя строка, должна
			СтрокаСПодвалом.Добавить(ПодписьГлавногоБухгалтера);             // помещаться и подпись гл.бухгалтера
		КонецЕсли;
		
		РазницаПоНаличию   = СтрокаОС.НаличиеФактическое - СтрокаОС.НаличиеПоДаннымУчета;
		РазницаПоСтоимости = СтрокаОС.СтоимостьФактическая - СтрокаОС.СтоимостьПоДаннымУчета;
		
		ИзлишекКоличество   = ?(РазницаПоНаличию > 0, РазницаПоНаличию, 0);
		ИзлишекСтоимость    = ?(РазницаПоСтоимости > 0, РазницаПоСтоимости, 0);
		НедостачаКоличество = ?(РазницаПоНаличию < 0, -РазницаПоНаличию, 0);
		НедостачаСтоимость  = ?(РазницаПоСтоимости < 0, -РазницаПоСтоимости, 0);
		
		ИтогИзлишекКоличество   = ИтогИзлишекКоличество + ИзлишекКоличество;
		ИтогИзлишекСтоимость    = ИтогИзлишекСтоимость + ИзлишекСтоимость;
		ИтогНедостачаКоличество = ИтогНедостачаКоличество + НедостачаКоличество;
		ИтогНедостачаСтоимость  = ИтогНедостачаСтоимость + НедостачаСтоимость;
		
		СтрокаТаблицы.Параметры.ИзлишекКоличество   = ИзлишекКоличество;
		СтрокаТаблицы.Параметры.ИзлишекСтоимость    = ИзлишекСтоимость;
		СтрокаТаблицы.Параметры.НедостачаКоличество = НедостачаКоличество;
		СтрокаТаблицы.Параметры.НедостачаСтоимость  = НедостачаСтоимость;
		
		// ИГС ИД Компания, Мостовых Д.В. 20.11.2017 {
		РегулировкаИзлишекНомерСчета 	= "";
		РегулировкаНедостачаНомерСчета 	= "";
		РегулировкаИзлишекКолво 		= 0;
		РегулировкаИзлишекСумма 		= 0;
		РегулировкаНедостачаКолво 		= 0;
		РегулировкаНедостачаСумма 		= 0;
		
		ДвиженияПоДокументам = ТаблицаДокументов.НайтиСтроки(Новый Структура("НомерСтроки", СтрокаОС.НомерСтроки));
		
		Для каждого СтрокаДвижение Из ДвиженияПоДокументам Цикл
			РегулировкаИзлишекСумма 	= РегулировкаИзлишекСумма 	 + СтрокаДвижение.РегулировкаИзлишекСумма;
			Если ЗначениеЗаполнено(СтрокаДвижение.РегулировкаИзлишекСумма)
				ИЛИ ЗначениеЗаполнено(СтрокаДвижение.РегулировкаИзлишекКолво) Тогда
				РегулировкаИзлишекНомерСчета = РегулировкаИзлишекНомерСчета + ?(РегулировкаИзлишекНомерСчета = "", "", ",")
					+ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаДвижение.Регистратор, "Номер");
				РегулировкаИзлишекКолво = РегулировкаИзлишекКолво + 1;
			КонецЕсли; 
			
			РегулировкаНедостачаСумма 	= РегулировкаНедостачаСумма  + СтрокаДвижение.РегулировкаНедостачаСумма;
			Если ЗначениеЗаполнено(СтрокаДвижение.РегулировкаНедостачаСумма)
				ИЛИ ЗначениеЗаполнено(СтрокаДвижение.РегулировкаНедостачаКолво) Тогда
				РегулировкаНедостачаНомерСчета = РегулировкаНедостачаНомерСчета + ?(РегулировкаНедостачаНомерСчета = "", "", ",")
					+ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаДвижение.Регистратор, "Номер");
				РегулировкаНедостачаКолво = РегулировкаНедостачаКолво + 1;
			КонецЕсли; 
		КонецЦикла; 
		
		ИтогоРегулировкаИзлишекКолво	= ИтогоРегулировкаИзлишекКолво 	 + РегулировкаИзлишекКолво;
		ИтогоРегулировкаИзлишекСумма 	= ИтогоРегулировкаИзлишекСумма 	 + РегулировкаИзлишекСумма;
		ИтогоРегулировкаНедостачаКолво 	= ИтогоРегулировкаНедостачаКолво + РегулировкаНедостачаКолво;
		ИтогоРегулировкаНедостачаСумма 	= ИтогоРегулировкаНедостачаСумма + РегулировкаНедостачаСумма;
		
		СтрокаТаблицы.Параметры.РегулировкаИзлишекКолво = РегулировкаИзлишекКолво;
		СтрокаТаблицы.Параметры.РегулировкаИзлишекСумма = РегулировкаИзлишекСумма;
		СтрокаТаблицы.Параметры.РегулировкаНедостачаКолво = РегулировкаНедостачаКолво;
		СтрокаТаблицы.Параметры.РегулировкаНедостачаСумма = РегулировкаНедостачаСумма;
		
		СтрокаТаблицы.Параметры.РегулировкаИзлишекКолво1 	= ИзлишекКоличество - РегулировкаИзлишекКолво;
		Если ИзлишекКоличество - РегулировкаИзлишекКолво <> 0 Тогда
			СтрокаТаблицы.Параметры.РегулировкаИзлишекСумма1 	= ИзлишекСтоимость - РегулировкаИзлишекСумма;
		КонецЕсли;
		
		Если НедостачаКоличество - РегулировкаНедостачаКолво > 0 Тогда
			СтрокаТаблицы.Параметры.РегулировкаНедостачаКолво1 	= НедостачаКоличество - РегулировкаНедостачаКолво;
			СтрокаТаблицы.Параметры.РегулировкаНедостачаСумма1 	= НедостачаСтоимость - РегулировкаНедостачаСумма;
		КонецЕсли;
		
		// Окончательные результаты
		Если ИзлишекКоличество - РегулировкаИзлишекКолво = - (НедостачаКоличество - РегулировкаНедостачаКолво) Тогда
		
			СтрокаТаблицы.Параметры.РегулировкаИзлишекКолво1 	= 0;
			СтрокаТаблицы.Параметры.РегулировкаИзлишекСумма1 	= 0;
			СтрокаТаблицы.Параметры.РегулировкаНедостачаКолво1 	= 0;
			СтрокаТаблицы.Параметры.РегулировкаНедостачаСумма1 	= 0;
			
		Иначе
			
			ИтогоРегулировкаИзлишекКолво1 	= ИтогоРегулировкаИзлишекКолво1 + ИзлишекКоличество - РегулировкаИзлишекКолво;
			Если ИзлишекКоличество - РегулировкаИзлишекКолво <> 0 Тогда
				ИтогоРегулировкаИзлишекСумма1 	= ИтогоРегулировкаИзлишекСумма1 + ИзлишекСтоимость - РегулировкаИзлишекСумма;
			КонецЕсли;
			
			Если НедостачаКоличество - РегулировкаНедостачаКолво > 0 Тогда
				
				ИтогоРегулировкаНедостачаКолво1 	= ИтогоРегулировкаНедостачаКолво1 + НедостачаКоличество - РегулировкаНедостачаКолво;
				ИтогоРегулировкаНедостачаСумма1 	= ИтогоРегулировкаНедостачаСумма1 + НедостачаСтоимость - РегулировкаНедостачаСумма;
				
			КонецЕсли;
			
		КонецЕсли; 
		
		СтрокаТаблицы.Параметры.РегулировкаИзлишекНомерСчета = РегулировкаИзлишекНомерСчета;
		СтрокаТаблицы.Параметры.РегулировкаНедостачаНомерСчета = РегулировкаНедостачаНомерСчета;
		// } ИГС ИД Компания, Мостовых Д.В. 
		
		
		ТабДокумент.Вывести(СтрокаТаблицы);
		
	КонецЦикла;
	
	// Выведем подвал таблицы
	ПодвалТаблицы.Параметры.ИтогИзлишекКоличество   = ИтогИзлишекКоличество;
	ПодвалТаблицы.Параметры.ИтогИзлишекСтоимость    = ИтогИзлишекСтоимость;
	ПодвалТаблицы.Параметры.ИтогНедостачаКоличество = ИтогНедостачаКоличество;
	ПодвалТаблицы.Параметры.ИтогНедостачаСтоимость  = ИтогНедостачаСтоимость;
	
	// ИГС ИД Компания, Мостовых Д.В. 20.11.2017 {
	ПодвалТаблицы.Параметры.ИтогоРегулировкаИзлишекКолво   = ИтогоРегулировкаИзлишекКолво;
	ПодвалТаблицы.Параметры.ИтогоРегулировкаИзлишекСумма   = ИтогоРегулировкаИзлишекСумма;
	ПодвалТаблицы.Параметры.ИтогоРегулировкаНедостачаКолво = ИтогоРегулировкаНедостачаКолво;
	ПодвалТаблицы.Параметры.ИтогоРегулировкаНедостачаСумма = ИтогоРегулировкаНедостачаСумма;
	//
	ПодвалТаблицы.Параметры.ИтогоРегулировкаИзлишекКолво1   = ИтогоРегулировкаИзлишекКолво1;
	ПодвалТаблицы.Параметры.ИтогоРегулировкаИзлишекСумма1  	= ИтогоРегулировкаИзлишекСумма1;
	ПодвалТаблицы.Параметры.ИтогоРегулировкаНедостачаКолво1 = ИтогоРегулировкаНедостачаКолво1;
	ПодвалТаблицы.Параметры.ИтогоРегулировкаНедостачаСумма1 = ИтогоРегулировкаНедостачаСумма1;
	// } ИГС ИД Компания, Мостовых Д.В. 
	
	ТабДокумент.Вывести(ПодвалТаблицы);
	
	// Выведем подпись бухгалтера
	Руководители = ОтветственныеЛицаБП.ОтветственныеЛица(Док.Организация, Док.Дата, Док.ПодразделениеОрганизации);
	
	ПодписьГлавногоБухгалтера.Параметры.РасшифровкаПодписи = Руководители.ГлавныйБухгалтер;
	
	ТабДокумент.Вывести(ПодписьГлавногоБухгалтера);
	
	// Проверим, помещаются ли шапка подписей и одна подпись
	Подписи = Новый Массив;
	Подписи.Добавить(ШапкаПодписейМОЛ);
	Подписи.Добавить(Подпись);
	
	Если НЕ ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабДокумент, Подписи) Тогда
			
		// Выведем разрыв страницы
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();

	КонецЕсли;
	
	// Выведем шапку подписей МОЛ
	ТабДокумент.Вывести(ШапкаПодписейМОЛ);
	
	// Выведем подписи МОЛов
	ЗаголовокРазделаПодписей = "Материально ответственное(ые) лицо(а)";
	ВыводитьЗаголовок = Истина;
	
	Возврат ТабДокумент;

КонецФункции

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
