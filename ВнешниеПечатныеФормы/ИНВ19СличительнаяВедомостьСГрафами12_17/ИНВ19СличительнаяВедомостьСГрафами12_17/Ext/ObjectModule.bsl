﻿Перем мВалютаРегламентированногоУчета;
Перем мВалютаУпрУчета;


Функция СведенияОВнешнейОбработке() Экспорт     
	
	ПараметрыРегистрации = Новый Структура;
	МассивНазначений = Новый Массив;
	МассивНазначений.Добавить("Документ.ИнвентаризацияТоваровНаСкладе"); //Указываем документ к которому делаем внешнюю печ. форму
	ПараметрыРегистрации.Вставить("Вид", "ПечатнаяФорма"); //может быть - ПечатнаяФорма, ЗаполнениеОбъекта, ДополнительныйОтчет, СозданиеСвязанныхОбъектов... 
	ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
	ПараметрыРегистрации.Вставить("Наименование", "ИНВ-19 (Сличительная ведомость с графами 12-17 регулировка с даты документа инветаризации) [v.24]"); //имя под которым обработка будет зарегестрирована в справочнике внешних обработок
	ПараметрыРегистрации.Вставить("БезопасныйРежим", ЛОЖЬ);
	ПараметрыРегистрации.Вставить("Версия", "1.0"); 
	ПараметрыРегистрации.Вставить("Информация", ""); 
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	ДобавитьКоманду(ТаблицаКоманд, "ИНВ-19 (Внешняя)", "ИНВ19", "открытиеФормы", Истина, "ПечатьMXL");
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции
Функция ПолучитьТаблицуКоманд()
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));//как будет выглядеть описание печ.формы для пользователя
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка")); //имя макета печ.формы
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

Функция Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода,НачалоКонецДняИнвентаризации) Экспорт
	СсылкаНаОбъект = МассивОбъектов[0];
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИнвентаризацияТоваровНаСкладе_ИНВ19_12_17";
	НомерСтраницы   = 2;
	ПечатьТабличногоДокумента(ТабДокумент, Ложь,	НомерСтраницы, НачалоКонецДняИнвентаризации);
	//УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,"ИНВ19","ИНВ19",ТабДокумент);
	возврат ТабДокумент;
КонецФункции 

Процедура ПечатьТабличногоДокумента(ТабДокумент, Знач ТолькоОбороты = Ложь, НомерСтраницы, НачалоКонецДняИнвентаризации = Ложь)
	
	Если ТолькоОбороты = Истина Тогда
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли; 
	
	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
		ТоварКод = "Артикул";
	Иначе
		ТоварКод = "Код";
	КонецЕсли;
	
	ВалютаПересчета = мВалютаРегламентированногоУчета;
	ВалютаПечати = мВалютаРегламентированногоУчета;
	Параметры    = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаПересчета, СсылкаНаОбъект.Дата);
	Запрос       = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", СсылкаНаОбъект);
	Запрос.Текст = "ВЫБРАТЬ
	|	ИнвентаризацияТоваровНаСкладе.Номер КАК НомерДокумента,
	|	ИнвентаризацияТоваровНаСкладе.Дата КАК ДатаДокумента,
	|	ИнвентаризацияТоваровНаСкладе.ДатаНачалаИнвентаризации КАК ДатаНачалаИнвентаризации,
	|	ИнвентаризацияТоваровНаСкладе.Организация КАК Руководители,
	|	ИнвентаризацияТоваровНаСкладе.Организация КАК Организация,
	|	ИнвентаризацияТоваровНаСкладе.Склад КАК Склад,
	|	ИнвентаризацияТоваровНаСкладе.Склад КАК ПредставлениеСклада,
	|	ИнвентаризацияТоваровНаСкладе.ДатаНачалаИнвентаризации КАК ДатаНачалаИнвентаризации1,
	|	ИнвентаризацияТоваровНаСкладе.ДатаОкончанияИнвентаризации КАК ДатаОкончанияИнвентаризации,
	|	ИнвентаризацияТоваровНаСкладе.ДокументОснованиеДата КАК ДокументОснованиеДата,
	|	ИнвентаризацияТоваровНаСкладе.ДокументОснованиеНомер КАК ОснованиеНомер,
	|	ИнвентаризацияТоваровНаСкладе.ДокументОснованиеВид КАК ОснованиеДата
	|ИЗ
	|	Документ.ИнвентаризацияТоваровНаСкладе КАК ИнвентаризацияТоваровНаСкладе
	|ГДЕ
	|	ИнвентаризацияТоваровНаСкладе.Ссылка = &ТекущийДокумент";
	
	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();
	
	Запрос.УстановитьПараметр("Курс",            Параметры.Курс);
	Запрос.УстановитьПараметр("Кратность",       Параметры.Кратность);
	Запрос.УстановитьПараметр("ВидСкладаНТТ",    Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	Товары1.НомерСтроки КАК Номер,
	|	Номенклатура1.Ссылка КАК Номенклатура,
	|	ПОДСТРОКА(Номенклатура1.НаименованиеПолное, 1, 255) КАК ТоварНаименование,
	|	Номенклатура1.Код КАК ТоварКод,
	|	КлассификаторЕдиницИзмерения.Представление КАК ЕдиницаИзмеренияНаименование,
	|	КлассификаторЕдиницИзмерения.Код КАК ЕдиницаИзмеренияКодПоОКЕИ,
	|	Товары1.Количество КАК ФактКоличество,
	|	Товары1.КоличествоУчет КАК БухКоличество,
	|	0 КАК Цена,
	|	ВЫБОР
	|		КОГДА Склады.ТипСклада = &ВидСкладаНТТ
	|			ТОГДА Товары1.Количество * Товары1.ЦенаВРознице
	|		ИНАЧЕ Товары1.Сумма * &Курс / &Кратность
	|	КОНЕЦ КАК ФактСумма,
	|	ВЫБОР
	|		КОГДА ИнвентаризацияТоваровНаСкладе.Склад.ТипСклада = &ВидСкладаНТТ
	|			ТОГДА Товары1.КоличествоУчет * Товары1.ЦенаВРознице
	|		ИНАЧЕ Товары1.СуммаУчет * &Курс / &Кратность
	|	КОНЕЦ КАК БухСумма
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	Документ.ИнвентаризацияТоваровНаСкладе.Товары КАК Товары1
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура1
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторЕдиницИзмерения КАК КлассификаторЕдиницИзмерения
	|			ПО Номенклатура1.ЕдиницаИзмерения = КлассификаторЕдиницИзмерения.Ссылка
	|		ПО Товары1.Номенклатура = Номенклатура1.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИнвентаризацияТоваровНаСкладе КАК ИнвентаризацияТоваровНаСкладе
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|			ПО ИнвентаризацияТоваровНаСкладе.Склад = Склады.Ссылка
	|		ПО Товары1.Ссылка = ИнвентаризацияТоваровНаСкладе.Ссылка
	|ГДЕ
	|	Товары1.Ссылка = &ТекущийДокумент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(Товары.Номер, 0) КАК Номер,
	|	ВЫБОР
	|		КОГДА ХозрасчетныйОбороты.КоличествоОборотДт > 0
	|			ТОГДА ХозрасчетныйОбороты.КоличествоОборотДт
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РегулировкаИзлишекКолво,
	|	ВЫБОР
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ПередачаМатериаловВЭксплуатацию
	|				И &Забалансовый
	|			ТОГДА 0
	|		КОГДА ХозрасчетныйОбороты.СуммаОборотДт > 0
	|			ТОГДА ХозрасчетныйОбороты.СуммаОборотДт
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РегулировкаИзлишекСумма,
	|	ВЫБОР
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ПередачаМатериаловВЭксплуатацию
	|				И &Забалансовый
	|			ТОГДА 0
	|		КОГДА ХозрасчетныйОбороты.КоличествоОборотКт > 0
	|			ТОГДА ХозрасчетныйОбороты.КоличествоОборотКт
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РегулировкаНедостачаКолво,
	|	ВЫБОР
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ПередачаМатериаловВЭксплуатацию
	|				И &Забалансовый
	|			ТОГДА 0
	|		КОГДА ХозрасчетныйОбороты.СуммаОборотКт > 0
	|			ТОГДА ХозрасчетныйОбороты.СуммаОборотКт
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РегулировкаНедостачаСумма,
	|	ВЫБОР
	|		КОГДА ХозрасчетныйОбороты.КоличествоОборотДт <= 0
	|			ТОГДА """"
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.ПоступлениеТоваровУслуг).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ПеремещениеТоваров
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.ПеремещениеТоваров).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ТребованиеНакладная
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.ТребованиеНакладная).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.СписаниеМатериаловИзЭксплуатации
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.СписаниеМатериаловИзЭксплуатации).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ПередачаМатериаловВЭксплуатацию
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.ПередачаМатериаловВЭксплуатацию).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ВозвратМатериаловИзЭксплуатации
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.ВозвратМатериаловИзЭксплуатации).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.РеализацияТоваровУслуг).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.СписаниеМатериаловИзЭксплуатации
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.СписаниеМатериаловИзЭксплуатации).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.КомплектацияНоменклатуры
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.КомплектацияНоменклатуры).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ПеремещениеОС
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.ПеремещениеОС).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.СписаниеТоваров
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.СписаниеТоваров).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ПересортицаТоваров
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.ПересортицаТоваров).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ОприходованиеТоваров
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.ОприходованиеТоваров).Номер
	|	КОНЕЦ КАК РегулировкаИзлишекНомерСчета,
	|	ХозрасчетныйОбороты.Субконто1 КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА ХозрасчетныйОбороты.КоличествоОборотКт <= 0
	|			ТОГДА """"
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.ПоступлениеТоваровУслуг).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ПеремещениеТоваров
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.ПеремещениеТоваров).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ТребованиеНакладная
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.ТребованиеНакладная).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.СписаниеМатериаловИзЭксплуатации
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.СписаниеМатериаловИзЭксплуатации).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ПередачаМатериаловВЭксплуатацию
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.ПередачаМатериаловВЭксплуатацию).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ВозвратМатериаловИзЭксплуатации
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.ВозвратМатериаловИзЭксплуатации).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.РеализацияТоваровУслуг).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.СписаниеМатериаловИзЭксплуатации
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.СписаниеМатериаловИзЭксплуатации).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.КомплектацияНоменклатуры
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.КомплектацияНоменклатуры).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ПеремещениеОС
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.ПеремещениеОС).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.СписаниеТоваров
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.СписаниеТоваров).Номер
	|		КОГДА ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ПересортицаТоваров
	|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.Регистратор КАК Документ.ПересортицаТоваров).Номер
	|	КОНЕЦ КАК РегулировкаНедостачаНомерСчета,
	|	ХозрасчетныйОбороты.Регистратор КАК Регистратор
	|ПОМЕСТИТЬ ВТОбороты
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Обороты(
	|				&НачалоПериода,
	|				,
	|				Регистратор,
	|				Счет В ИЕРАРХИИ (&СписокСчетов),
	|				&СубконтоНоменклатураСклад,
	|				Субконто2 = &Склад
	|					ИЛИ Субконто2 = &СкладИзШапки,
	|				,
	|				) КАК ХозрасчетныйОбороты
	|		ПО Товары.Номенклатура = ХозрасчетныйОбороты.Субконто1
	|ГДЕ
	|	НЕ(ХозрасчетныйОбороты.Счет.Код = ""МЦ.06""
	|				И ХозрасчетныйОбороты.КорСчет.Код = ""МЦ.04""
	|				И ХозрасчетныйОбороты.КорСчет <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка))
	|	И НЕ(ХозрасчетныйОбороты.Счет.Код = ""МЦ.04""
	|				И ХозрасчетныйОбороты.КорСчет.Код = ""МЦ.06""
	|				И ХозрасчетныйОбороты.КорСчет <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТОбороты.Номер КАК Номер
	|ПОМЕСТИТЬ СтрокиСОборотами
	|ИЗ
	|	ВТОбороты КАК ВТОбороты
	|ГДЕ
	|	НЕ ВТОбороты.Номер = 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Товары.Номер КАК Номер,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.ТоварНаименование КАК ТоварНаименование,
	|	Товары.ТоварКод КАК ТоварКод,
	|	Товары.ЕдиницаИзмеренияНаименование КАК ЕдиницаИзмеренияНаименование,
	|	Товары.ЕдиницаИзмеренияКодПоОКЕИ КАК ЕдиницаИзмеренияКодПоОКЕИ,
	|	Товары.ФактКоличество КАК ФактКоличество,
	|	Товары.БухКоличество КАК БухКоличество,
	|	Товары.Цена КАК Цена,
	|	Товары.ФактСумма КАК ФактСумма,
	|	Товары.БухСумма КАК БухСумма
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ СтрокиСОборотами КАК СтрокиСОборотами
	|		ПО Товары.Номер = СтрокиСОборотами.Номер
	|ГДЕ
	|	Товары.ФактКоличество - Товары.БухКоличество <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТОбороты.Номер КАК Номер,
	|	ВТОбороты.РегулировкаИзлишекКолво КАК РегулировкаИзлишекКолво,
	|	ВТОбороты.РегулировкаИзлишекСумма КАК РегулировкаИзлишекСумма,
	|	ВТОбороты.РегулировкаНедостачаКолво КАК РегулировкаНедостачаКолво,
	|	ВТОбороты.РегулировкаНедостачаСумма КАК РегулировкаНедостачаСумма,
	|	ВТОбороты.РегулировкаИзлишекНомерСчета КАК РегулировкаИзлишекНомерСчета,
	|	ВТОбороты.РегулировкаНедостачаНомерСчета КАК РегулировкаНедостачаНомерСчета,
	|	ВТОбороты.Номенклатура КАК Номенклатура
	|ИЗ
	|	ВТОбороты КАК ВТОбороты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТОбороты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ СтрокиСОборотами";
	
	Если НачалоКонецДняИнвентаризации = Ложь Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&НачалоПериода", "НачалоПериода(&НачалоПериода,ДЕНЬ)");
	Иначе
		 Запрос.Текст = СтрЗаменить(Запрос.Текст, "&НачалоПериода", "КОНЕЦПЕРИОДА(&НачалоПериода,ДЕНЬ)"); 
	КонецЕсли;
	СписокСчетов = Новый Массив();
	СубконтоНоменклатураСклад = Новый Массив();
	Если СсылкаНаОбъект.Товары[0].СчетУчета.Забалансовый
		И СсылкаНаОбъект.Товары[0].СчетУчета.Код = "МЦ.04.А" Тогда
		СписокСчетов.Добавить(СсылкаНаОбъект.Товары[0].СчетУчета);
		
		СубконтоНоменклатураСклад.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
		СубконтоНоменклатураСклад.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
		Запрос.УстановитьПараметр("Склад", 			Шапка.Склад);
		Запрос.УстановитьПараметр("Забалансовый",	Истина);
		
		Запрос.УстановитьПараметр("СкладИзШапки", Неопределено);
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Субконто3 = &Склад ИЛИ Субконто3 = &СкладИзШапки", "ЛОЖЬ");
	ИначеЕсли СсылкаНаОбъект.Товары[0].СчетУчета.Забалансовый Тогда
		
		СписокСчетов.Добавить(СсылкаНаОбъект.Товары[0].СчетУчета);
		СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.НайтиПоКоду("МЦ.06"));
		
		//СубконтоНоменклатураСклад.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
		//СубконтоНоменклатураСклад.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.РаботникиОрганизации);
		//СубконтоНоменклатураСклад.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
		
		// Получаем ответственное лицо для случая инвентаризации по забалансу
		ОтборСклад = Новый Структура("СтруктурнаяЕдиница", Шапка.Склад);
		Работник = РегистрыСведений.ОтветственныеЛица.ПолучитьПоследнее(СсылкаНаОбъект.Дата, ОтборСклад).ФизическоеЛицо;
		Запрос.УстановитьПараметр("Склад", 			Работник);
		Запрос.УстановитьПараметр("Забалансовый",	Истина);
		Запрос.УстановитьПараметр("СкладИзШапки",	СсылкаНаОбъект.Склад);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&СубконтоНоменклатураСклад", "");
		
	Иначе
		
		СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.ОборудованиеКУстановке);
		СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.ВложенияВоВнеоборотныеАктивы);
		СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.Материалы);
		
		СубконтоНоменклатураСклад.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
		СубконтоНоменклатураСклад.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
		Запрос.УстановитьПараметр("Склад", 			Шапка.Склад);
		Запрос.УстановитьПараметр("Забалансовый",	Истина);
		
		Запрос.УстановитьПараметр("СкладИзШапки", Неопределено);
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Субконто3 = &Склад ИЛИ Субконто3 = &СкладИзШапки", "ЛОЖЬ");
		
	КонецЕсли;	
	
	Запрос.УстановитьПараметр("СписокСчетов", 	СписокСчетов);
	Запрос.УстановитьПараметр("СубконтоНоменклатураСклад", СубконтоНоменклатураСклад);
	Запрос.УстановитьПараметр("ТолькоОбороты",	ТолькоОбороты);
	Запрос.УстановитьПараметр("НачалоПериода", 	КонецДня(Шапка.ДатаДокумента) + 1);
	Запрос.УстановитьПараметр("КонецПериода", 	?(ЗначениеЗаполнено(Шапка.ДатаНачалаИнвентаризации1), 
	Новый Граница(КонецДня(Шапка.ДатаНачалаИнвентаризации1), ВидГраницы.Включая), 
	Новый Граница(КонецДня(Шапка.ДатаДокумента), ВидГраницы.Включая)));
	
	Запрос.УстановитьПараметр("КонецПериодаДата", 	?(ЗначениеЗаполнено(Шапка.ДатаНачалаИнвентаризации1), 
	КонецДня(Шапка.ДатаНачалаИнвентаризации1), 
	КонецДня(Шапка.ДатаДокумента)));
	
	Запрос.УстановитьПараметр("ДатаОкончанияГодовойИнвентаризации", Дата(1,1,1));
	
	Пакет = Запрос.ВыполнитьПакет();
	
	ВыборкаСтрокТовары = Пакет[3].Выбрать();
	Если ВыборкаСтрокТовары.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаДокументов  = Пакет[4].Выгрузить();
	ТаблицаДокументов.Индексы.Добавить("Номер");
	ТаблицаДокументов.Индексы.Добавить("Номенклатура");
	
	Макет       = ПолучитьМакет("ИНВ19");
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	СведенияОбОрганизации =БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Организация,Шапка.ДатаДокумента);
	ОбластьМакета.Параметры.ПредставлениеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации,
	"НаименованиеДляПечатныхФорм,ИНН,ФактическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет");
	ОбластьМакета.Параметры.ОрганизацияПоОКПО        = СведенияОбОрганизации.КодПоОКПО;
	ОбластьМакета.Параметры.ДатаДокумента            = Шапка.ДатаДокумента;
	ОбластьМакета.Параметры.ДатаНачалаИнвентаризации = Шапка.ДатаНачалаИнвентаризации;
	ОбластьМакета.Параметры.НомерДокумента           = СсылкаНаОбъект.Номер;
	ОбластьМакета.Параметры.ПредставлениеПодразделения= Шапка.Склад;
	
	ОтборРуководитель = новый Структура();
	ОтборРуководитель.Вставить("СтруктурнаяЕдиница", Шапка.руководители);
	ОтборРуководитель.Вставить("ОтветственноеЛицо", Перечисления.ОтветственныеЛицаОрганизаций.Руководитель);
	ЗапросРуководителя = РегистрыСведений.ОтветственныеЛицаОрганизаций.получитьПоследнее(Шапка.ДатаДокумента,ОтборРуководитель);
	Если ЗапросРуководителя <> неопределено Тогда
		Руководитель = ЗапросРуководителя.ФизическоеЛицо;
	КонецЕсли;
	
	ОтборБухгалтер = новый Структура();
	ОтборБухгалтер.Вставить("СтруктурнаяЕдиница", Шапка.руководители);
	ОтборБухгалтер.Вставить("ОтветственноеЛицо", Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер);
	ЗапросБухгалтер = РегистрыСведений.ОтветственныеЛицаОрганизаций.получитьПоследнее(Шапка.ДатаДокумента,ОтборБухгалтер);
	Если ЗапросБухгалтер <> Неопределено Тогда
		Бухгалтер = ЗапросБухгалтер.ФизическоеЛицо;
	КонецЕсли;
	
	Если ТолькоОбороты = Ложь Тогда
		ТабДокумент.Вывести(ОбластьМакета);
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;
	
	ИтогоРезультатИзлишекКолво   = 0;
	ИтогоРезультатИзлишекСумма   = 0;
	ИтогоРезультатНедостачаКолво = 0;
	ИтогоРезультатНедостачаСумма = 0;
	
	ИтогоРегулировкаИзлишекКолво = 0;
	ИтогоРегулировкаИзлишекСумма = 0;
	ИтогоРегулировкаНедостачаКолво = 0;
	ИтогоРегулировкаНедостачаСумма = 0;
	
	ИтогоСписаниеНедостачКолонка1Колво = 0;
	ИтогоСписаниеНедостачКолонка1Сумма = 0;
	ИтогоСписаниеНедостачКолонка2Колво = 0;
	ИтогоСписаниеНедостачКолонка2Сумма = 0;
	ИтогоФактКоличество = 0;
	ИтогоФактСумма = 0;
	
	ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы1");
	ЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы; 
	ТабДокумент.Вывести(ЗаголовокТаблицы);
	
	КоличествоСтрок = ВыборкаСтрокТовары.Количество();  
	
	ОбластьМакета              = Макет.ПолучитьОбласть("СтрокаТаблицы1");
	ОбластьИтоговПоСтранице    = Макет.ПолучитьОбласть("ИтогоТаблицы1");
	ОбластьПодвала             = Макет.ПолучитьОбласть("Подвал");
	МассивВыводимыхОбластей    = Новый Массив;
	Ном = 0;
	
	МассивНоменклатуры = Новый Массив();
	
	Пока ВыборкаСтрокТовары.Следующий() Цикл
		
		Ном = Ном + 1;
		
		Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
			Сообщить("В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.", СтатусСообщения.Важное);
			Продолжить;
		КонецЕсли;
		
		Если МассивНоменклатуры.Найти(ВыборкаСтрокТовары.Номенклатура) <> Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		
		МассивНоменклатуры.Добавить(ВыборкаСтрокТовары.Номенклатура);
		
		ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
		
		Если ВыборкаСтрокТовары.Номер = 0 Тогда
			ОбластьМакета.Параметры.Номер = "";
		КонецЕсли; 
		
		ОбластьМакета.Параметры.ТоварНаименование = ВыборкаСтрокТовары.ТоварНаименование ;
		
		Разница     = 0;
		РазницаСумм = 0;
		
		Разница     = ВыборкаСтрокТовары.ФактКоличество - ВыборкаСтрокТовары.БухКоличество;
		РазницаСумм = ВыборкаСтрокТовары.ФактСумма      - ВыборкаСтрокТовары.БухСумма;
		
		Если Разница < 0 И РазницаСумм < 0 Тогда
			ОбластьМакета.Параметры.РезультатНедостачаКолво = - Разница;
			ОбластьМакета.Параметры.РезультатНедостачаСумма = - РазницаСумм;
			ОбластьМакета.Параметры.РезультатИзлишекКолво   = 0;
			ОбластьМакета.Параметры.РезультатИзлишекСумма   = 0;
			
			ИтогоРезультатНедостачаКолво = ИтогоРезультатНедостачаКолво + (- Разница);
			ИтогоРезультатНедостачаСумма = ИтогоРезультатНедостачаСумма + (- РазницаСумм);
		ИначеЕсли Разница < 0 И РазницаСумм >= 0 Тогда
			ОбластьМакета.Параметры.РезультатНедостачаКолво = - Разница;
			ОбластьМакета.Параметры.РезультатНедостачаСумма = РазницаСумм;
			ОбластьМакета.Параметры.РезультатИзлишекКолво   = 0;
			ОбластьМакета.Параметры.РезультатИзлишекСумма   = 0;
			
			ИтогоРезультатНедостачаКолво = ИтогоРезультатНедостачаКолво + (- Разница);
			ИтогоРезультатНедостачаСумма = ИтогоРезультатНедостачаСумма + РазницаСумм;
		Иначе
			ОбластьМакета.Параметры.РезультатНедостачаКолво = 0;
			ОбластьМакета.Параметры.РезультатНедостачаСумма = 0;
			ОбластьМакета.Параметры.РезультатИзлишекКолво   = Разница;
			ОбластьМакета.Параметры.РезультатИзлишекСумма   = РазницаСумм;
			
			ИтогоРезультатИзлишекКолво   = ИтогоРезультатИзлишекКолво   + Разница;
			ИтогоРезультатИзлишекСумма   = ИтогоРезультатИзлишекСумма   + РазницаСумм;
		КонецЕсли;
		РегулировкаИзлишекНомерСчета 	= "";
		РегулировкаНедостачаНомерСчета 	= "";
		РегулировкаИзлишекКолво 		= 0;
		РегулировкаИзлишекСумма 		= 0;
		РегулировкаНедостачаКолво 		= 0;
		РегулировкаНедостачаСумма 		= 0;
		
		ДвиженияПоДокументам = 	ТаблицаДокументов.НайтиСтроки(Новый Структура("Номенклатура", ВыборкаСтрокТовары.Номенклатура));
		
		Для каждого СтрокаДвижение Из ДвиженияПоДокументам Цикл
			
			Если СтрокаДвижение.РегулировкаИзлишекКолво <> 0 
				И СтрокаДвижение.РегулировкаНедостачаКолво <> 0 Тогда
				
				Если СтрокаДвижение.РегулировкаИзлишекКолво > СтрокаДвижение.РегулировкаНедостачаКолво Тогда
					
					СтрокаДвижение.РегулировкаИзлишекКолво = СтрокаДвижение.РегулировкаИзлишекКолво - СтрокаДвижение.РегулировкаНедостачаКолво;
					СтрокаДвижение.РегулировкаНедостачаКолво = 0;
					
				ИначеЕсли СтрокаДвижение.РегулировкаИзлишекКолво < СтрокаДвижение.РегулировкаНедостачаКолво Тогда
					
					СтрокаДвижение.РегулировкаНедостачаКолво = СтрокаДвижение.РегулировкаНедостачаКолво - СтрокаДвижение.РегулировкаИзлишекКолво;
					СтрокаДвижение.РегулировкаИзлишекКолво = 0;
					
				Иначе
					
					СтрокаДвижение.РегулировкаИзлишекКолво = 0;
					СтрокаДвижение.РегулировкаНедостачаКолво = 0;
					
					Продолжить;
					
				КонецЕсли; 	
				
			КонецЕсли; 
			
			Если СтрокаДвижение.РегулировкаИзлишекКолво > 0 Тогда
				
				Если ОбластьМакета.Параметры.РезультатИзлишекКолво > РегулировкаИзлишекКолво Тогда
					
					Разница = ОбластьМакета.Параметры.РезультатИзлишекКолво - РегулировкаИзлишекКолво;
					
					РегулировкаИзлишекКолво = РегулировкаИзлишекКолво + ?(СтрокаДвижение.РегулировкаИзлишекКолво < Разница, СтрокаДвижение.РегулировкаИзлишекКолво, Разница);
					РегулировкаИзлишекСумма = РегулировкаИзлишекСумма + ?(СтрокаДвижение.РегулировкаИзлишекКолво < Разница, СтрокаДвижение.РегулировкаИзлишекСумма, СтрокаДвижение.РегулировкаИзлишекСумма / СтрокаДвижение.РегулировкаИзлишекКолво * Разница);
					
					Если ЗначениеЗаполнено(СтрокаДвижение.РегулировкаИзлишекНомерСчета) Тогда
						РегулировкаИзлишекНомерСчета = РегулировкаИзлишекНомерСчета + ?(РегулировкаИзлишекНомерСчета = "", "", ",") + СтрокаДвижение.РегулировкаИзлишекНомерСчета;
					КонецЕсли;
					
					Если ОбластьМакета.Параметры.РезультатИзлишекКолво = РегулировкаИзлишекКолво 
						И ОбластьМакета.Параметры.РезультатИзлишекСумма <> 0 Тогда
						РегулировкаИзлишекСумма = ОбластьМакета.Параметры.РезультатИзлишекСумма;
					КонецЕсли; 
					
				КонецЕсли;
				
			ИначеЕсли СтрокаДвижение.РегулировкаНедостачаКолво > 0 Тогда 
				
				Если ОбластьМакета.Параметры.РезультатНедостачаКолво > РегулировкаНедостачаКолво Тогда
					
					Разница = ОбластьМакета.Параметры.РезультатНедостачаКолво - РегулировкаНедостачаКолво;
					
					РегулировкаНедостачаКолво = РегулировкаНедостачаКолво + ?(СтрокаДвижение.РегулировкаНедостачаКолво < Разница, СтрокаДвижение.РегулировкаНедостачаКолво, Разница);
					РегулировкаНедостачаСумма = РегулировкаНедостачаСумма + ?(СтрокаДвижение.РегулировкаНедостачаКолво < Разница, СтрокаДвижение.РегулировкаНедостачаСумма, СтрокаДвижение.РегулировкаНедостачаСумма / СтрокаДвижение.РегулировкаНедостачаКолво * Разница);
					
					Если ЗначениеЗаполнено(СтрокаДвижение.РегулировкаНедостачаНомерСчета) Тогда
						РегулировкаНедостачаНомерСчета = РегулировкаНедостачаНомерСчета + ?(РегулировкаНедостачаНомерСчета = "", "", ",") + СтрокаДвижение.РегулировкаНедостачаНомерСчета;
					КонецЕсли;
					
					Если ОбластьМакета.Параметры.РезультатНедостачаКолво = РегулировкаНедостачаКолво 
						И ОбластьМакета.Параметры.РезультатНедостачаСумма <> 0 Тогда
						РегулировкаНедостачаСумма = ОбластьМакета.Параметры.РезультатНедостачаСумма;
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла; 
		
		ИтогоРегулировкаИзлишекКолво	= ИтогоРегулировкаИзлишекКолво 	 + РегулировкаИзлишекКолво;
		ИтогоРегулировкаИзлишекСумма 	= ИтогоРегулировкаИзлишекСумма 	 + РегулировкаИзлишекСумма;
		ИтогоРегулировкаНедостачаКолво 	= ИтогоРегулировкаНедостачаКолво + РегулировкаНедостачаКолво;
		ИтогоРегулировкаНедостачаСумма 	= ИтогоРегулировкаНедостачаСумма + РегулировкаНедостачаСумма;
		
		
		// Окончательные результаты
		СписаниеНедостачКолонка1Колво = 0;
		СписаниеНедостачКолонка2Колво = 0;
		СписаниеНедостачКолонка1Сумма = 0;
		СписаниеНедостачКолонка2Сумма = 0;
		
		СписаниеНедостачКолонка1Колво = ОбластьМакета.Параметры.РезультатИзлишекКолво - РегулировкаИзлишекКолво;
		Если СписаниеНедостачКолонка1Колво < 0 Тогда
			СписаниеНедостачКолонка2Колво = -СписаниеНедостачКолонка1Колво;
			СписаниеНедостачКолонка1Колво = 0;
		КонецЕсли; 
		СписаниеНедостачКолонка1Сумма = ОбластьМакета.Параметры.РезультатИзлишекСумма - РегулировкаИзлишекСумма;
		Если СписаниеНедостачКолонка1Сумма < 0 Тогда
			СписаниеНедостачКолонка2Сумма = -СписаниеНедостачКолонка1Сумма;
			СписаниеНедостачКолонка1Сумма = 0;
		КонецЕсли; 
		
		СписаниеНедостачКолонка2Колво = СписаниеНедостачКолонка2Колво + ОбластьМакета.Параметры.РезультатНедостачаКолво - РегулировкаНедостачаКолво;
		Если СписаниеНедостачКолонка2Колво < 0 Тогда
			СписаниеНедостачКолонка1Колво = СписаниеНедостачКолонка1Колво - СписаниеНедостачКолонка2Колво;
			СписаниеНедостачКолонка2Колво = 0;
		КонецЕсли; 
		СписаниеНедостачКолонка2Сумма = СписаниеНедостачКолонка2Сумма + ОбластьМакета.Параметры.РезультатНедостачаСумма - РегулировкаНедостачаСумма;
		Если СписаниеНедостачКолонка2Сумма < 0 Тогда
			СписаниеНедостачКолонка1Сумма = СписаниеНедостачКолонка1Сумма - СписаниеНедостачКолонка2Сумма;
			СписаниеНедостачКолонка2Сумма = 0;		
		КонецЕсли; 
		Если СписаниеНедостачКолонка1Колво = 0 Тогда
			СписаниеНедостачКолонка1Сумма = 0;	
		КонецЕсли; 
		Если СписаниеНедостачКолонка2Колво = 0 Тогда
			СписаниеНедостачКолонка2Сумма = 0;
		КонецЕсли; 
		
		ИтогоСписаниеНедостачКолонка1Колво	= ИтогоСписаниеНедостачКолонка1Колво 	 + СписаниеНедостачКолонка1Колво;
		ИтогоСписаниеНедостачКолонка1Сумма 	= ИтогоСписаниеНедостачКолонка1Сумма 	 + СписаниеНедостачКолонка1Сумма;
		ИтогоСписаниеНедостачКолонка2Колво 	= ИтогоСписаниеНедостачКолонка2Колво + СписаниеНедостачКолонка2Колво;
		ИтогоСписаниеНедостачКолонка2Сумма 	= ИтогоСписаниеНедостачКолонка2Сумма + СписаниеНедостачКолонка2Сумма;
		ИтогоФактКоличество = ИтогоФактКоличество + ВыборкаСтрокТовары.ФактКоличество;
		ИтогоФактСумма = ИтогоФактСумма + ВыборкаСтрокТовары.ФактСумма;
		
		ОбластьМакета.Параметры.РегулировкаИзлишекКолво = РегулировкаИзлишекКолво;
		ОбластьМакета.Параметры.РегулировкаИзлишекСумма = РегулировкаИзлишекСумма;
		ОбластьМакета.Параметры.РегулировкаНедостачаКолво = РегулировкаНедостачаКолво;
		ОбластьМакета.Параметры.РегулировкаНедостачаСумма = РегулировкаНедостачаСумма;
		ОбластьМакета.Параметры.РегулировкаИзлишекНомерСчета = РегулировкаИзлишекНомерСчета;
		ОбластьМакета.Параметры.РегулировкаНедостачаНомерСчета = РегулировкаНедостачаНомерСчета;
		
		ОбластьМакета.Параметры.СписаниеНедостачКолонка1Колво = СписаниеНедостачКолонка1Колво;
		ОбластьМакета.Параметры.СписаниеНедостачКолонка1Сумма = СписаниеНедостачКолонка1Сумма;
		ОбластьМакета.Параметры.СписаниеНедостачКолонка2Колво = СписаниеНедостачКолонка2Колво;
		ОбластьМакета.Параметры.СписаниеНедостачКолонка2Сумма = СписаниеНедостачКолонка2Сумма;	
		МассивВыводимыхОбластей.Очистить();
		МассивВыводимыхОбластей.Добавить(ОбластьМакета);
		МассивВыводимыхОбластей.Добавить(ОбластьИтоговПоСтранице);
		Если Ном = КоличествоСтрок Тогда
			МассивВыводимыхОбластей.Добавить(ОбластьПодвала);
		КонецЕсли;
		
		//Если НЕ ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ТабДокумент, МассивВыводимыхОбластей) Тогда
		//	
		//	НомерСтраницы = НомерСтраницы + 1;
		//	ТабДокумент.Вывести(ОбластьИтоговПоСтранице);
		//	ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		//	ЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы;
		//	ТабДокумент.Вывести(ЗаголовокТаблицы);
		//	
		//КонецЕсли; 
		
		ТабДокумент.Вывести(ОбластьМакета);
		
	КонецЦикла;
	
	ОбластьИтоговПоСтранице.Параметры.ИтогоРезультатИзлишекКолво   = ИтогоРезультатИзлишекКолво;
	ОбластьИтоговПоСтранице.Параметры.ИтогоРезультатИзлишекСумма   = ИтогоРезультатИзлишекСумма;
	ОбластьИтоговПоСтранице.Параметры.ИтогоРезультатНедостачаКолво = ИтогоРезультатНедостачаКолво;
	ОбластьИтоговПоСтранице.Параметры.ИтогоРезультатНедостачаСумма = ИтогоРезультатНедостачаСумма;
	
	// ИГС ИД Компания, Мостовых Д.В. 20.11.2017 {
	ОбластьИтоговПоСтранице.Параметры.ИтогоРегулировкаИзлишекКолво   = ИтогоРегулировкаИзлишекКолво;
	ОбластьИтоговПоСтранице.Параметры.ИтогоРегулировкаИзлишекСумма   = ИтогоРегулировкаИзлишекСумма;
	ОбластьИтоговПоСтранице.Параметры.ИтогоРегулировкаНедостачаКолво = ИтогоРегулировкаНедостачаКолво;
	ОбластьИтоговПоСтранице.Параметры.ИтогоРегулировкаНедостачаСумма = ИтогоРегулировкаНедостачаСумма;
	
	ОбластьИтоговПоСтранице.Параметры.ИтогоСписаниеНедостачКолонка1Колво   = ИтогоСписаниеНедостачКолонка1Колво;
	ОбластьИтоговПоСтранице.Параметры.ИтогоСписаниеНедостачКолонка1Сумма   = ИтогоСписаниеНедостачКолонка1Сумма;
	ОбластьИтоговПоСтранице.Параметры.ИтогоСписаниеНедостачКолонка2Колво = ИтогоСписаниеНедостачКолонка2Колво;
	ОбластьИтоговПоСтранице.Параметры.ИтогоСписаниеНедостачКолонка2Сумма = ИтогоСписаниеНедостачКолонка2Сумма;
	
	ОбластьИтоговПоСтранице.Параметры.ИтогоФактКоличество 	= ИтогоФактКоличество;
	ОбластьИтоговПоСтранице.Параметры.ИтогоФактСумма 		= ИтогоФактСумма;
	
	// } ИГС ИД Компания, Мостовых Д.В. 
	
	ТабДокумент.Вывести(ОбластьИтоговПоСтранице);
	
	ОбластьПодвала.Параметры.ФИОБухгалтера =  Бухгалтер;
	ОбластьПодвала.Параметры.Заполнить(Шапка);
	Если ТолькоОбороты = Ложь Тогда
		ТабДокумент.Вывести(ОбластьПодвала);
	КонецЕсли; 
	
	// Зададим параметры макета
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
КонецПроцедуры



мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
