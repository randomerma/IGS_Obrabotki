﻿
&НаСервере
Процедура СформироватьНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	игсАрендованныеОСОстатки.ОсновноеСредство КАК ОсновноеСредство,
	               |	игсАрендованныеОСОстатки.Контрагент КАК Контрагент,
	               |	игсАрендованныеОСОстатки.ДоговорКонтрагента КАК ДоговорКонтрагента,
	               |	игсАрендованныеОСОстатки.Склад КАК Склад,
	               |	игсАрендованныеОСОстатки.СуммаОстаток КАК СуммаОстаток
	               |ИЗ
	               |	РегистрНакопления.игсАрендованныеОС.Остатки(
	               |			&Дата,
	               |			ДоговорКонтрагента = &Договор
	               |				И Контрагент = &Контрагент
	               |				И Организация = &Организация
	               |				И Склад = &Склад) КАК игсАрендованныеОСОстатки";
	Если Объект.Договор.Пустая() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ДоговорКонтрагента = &Договор","Истина");
	Иначе
		Запрос.УстановитьПараметр("Договор", объект.Договор);
	КонецЕсли;
	Если Объект.Контрагент.Пустая() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Контрагент = &Контрагент","Истина");
	Иначе
		Запрос.УстановитьПараметр("Контрагент", объект.Контрагент);
	КонецЕсли;
	Если Объект.Организация.Пустая() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Организация = &Организация","Истина");
	Иначе
		Запрос.УстановитьПараметр("Организация", объект.Организация);
	КонецЕсли;
	Если Объект.Склад.Пустая() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Склад = &Склад","Истина");
	Иначе
		Запрос.УстановитьПараметр("Склад", объект.Склад);
	КонецЕсли;
	Если Объект.Дата = Дата('00010101') Тогда
		Запрос.УстановитьПараметр("Дата", новый Граница(ТекущаяДатаСеанса(), ВидГраницы.Включая));
	Иначе
		Запрос.УстановитьПараметр("Дата", Новый Граница(объект.Дата, ВидГраницы.Включая));
	КонецЕсли;

	
	Результат = Запрос.Выполнить();
	ЦелевойОбъект = Объект.СсылкаНаОбъект.ПолучитьОбъект();
    ЦелевойОбъект.РасходОС.Очистить();

	Если не Результат.Пустой() Тогда
		ОСДляЗаполнения = Результат.Выгрузить();
		для каждого ОС из ОСДляЗаполнения цикл
			НоваяСтрока = ЦелевойОбъект.РасходОс.Добавить();
			НоваяСтрока.ОсновноеСредство = ОС.ОсновноеСредство;
			НоваяСтрока.Контрагент = ОС.Контрагент;
			НоваяСтрока.ДоговорКонтрагента = ОС.ДоговорКонтрагента;
			НоваяСтрока.Склад = ОС.Склад;
			НоваяСтрока.Сумма = ОС.СуммаОстаток;
		КонецЦикла;
		ЦелевойОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Прочитать();
	КонецЕсли;

	ЭтотОбъект.Закрыть();

КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ) 
	Если не объект.СсылкаНаОбъект.Пустая() Тогда
		Элементы.СсылкаНаОбъект.Видимость = Ложь;
		ПолучитьДанныеИсходногоДокумента();
	КонецЕсли;
КонецПроцедуры 

&НаСервере
Процедура ПолучитьДанныеИсходногоДокумента()
	ИсходныйОбъект = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(объект.СсылкаНаОбъект,"Контрагент, Организация, Дата",Истина,);
	объект.Организация  = ИсходныйОбъект.Организация;
	Объект.Дата = ИсходныйОбъект.Дата;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		Объект.СсылкаНаОбъект = Параметры.СсылкаНаОбъект;
КонецПроцедуры

&НаКлиенте
Процедура СсылкаНаОбъектПриИзменении(Элемент)
	ПриОткрытии(ложь);
КонецПроцедуры
