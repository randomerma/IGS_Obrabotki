﻿
&НаСервере
Функция ПечатьНаСервере()
	 ДокументОбъект = РеквизитФормыВЗначение("Объект");
	 МассивПечати = новый Массив;
	 МассивПечати.Добавить(ДокументОбъект.ссылканаОбъект);
	 результат = ДокументОбъект.Печать(МассивПечати,новый ТаблицаЗначений, новый СписокЗначений, новый Структура);
	 возврат Результат;
Конецфункции

&НаКлиенте
Процедура Печать(Команда)
	Результат = ПечатьнаСервере();
	Результат.Показать();
КонецПроцедуры
