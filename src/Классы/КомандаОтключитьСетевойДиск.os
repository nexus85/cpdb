
///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Перем Лог;

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт
	
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, "Отключить сетевой диск");

	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "ИмяУстройства", "Имя устройства (буква диска)");

    Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры

Функция ВыполнитьКоманду(Знач ПараметрыКоманды) Экспорт
    
	ИмяУстройства		= ПараметрыКоманды["ИмяУстройства"];

	ВозможныйРезультат = МенеджерКомандПриложения.РезультатыКоманд();

	Если ПустаяСтрока(ИмяУстройства) Тогда
		Лог.Ошибка("Не указано имя устройства");
		Возврат ВозможныйРезультат.НеверныеПараметры;
	КонецЕсли;

	Попытка
		ОписаниеРезультата = "";
		
		Результат = ОтключитьДиск(ИмяУстройства, ОписаниеРезультата);

		Если Не ПустаяСтрока(ОписаниеРезультата) Тогда
			Лог.Информация("Вывод команды: " + ОписаниеРезультата);
		КонецЕсли;
		
		Если НЕ Результат Тогда
			Возврат ВозможныйРезультат.ОшибкаВремениВыполнения;
		КонецЕсли;

		Возврат ВозможныйРезультат.Успех;
	Исключение
		Лог.Ошибка("Вывод команды: " + ОписаниеРезультата + Символы.ПС + ОписаниеОшибки());
		Возврат ВозможныйРезультат.ОшибкаВремениВыполнения;
	КонецПопытки;

КонецФункции

Функция ОтключитьДиск(ИмяУстройства, ОписаниеРезультата = "") Экспорт

	КомандаРК = Новый Команда;
	
	КомандаРК.УстановитьКоманду("net");
	КомандаРК.ДобавитьПараметр("use");
	КомандаРК.ДобавитьПараметр(ИмяУстройства);
	КомандаРК.ДобавитьПараметр("/DELETE");

	КомандаРК.УстановитьИсполнениеЧерезКомандыСистемы( Ложь );
	КомандаРК.ПоказыватьВыводНемедленно( Ложь );
	
	КодВозврата = КомандаРК.Исполнить();

	ОписаниеРезультата = КомандаРК.ПолучитьВывод();
	
	Возврат КодВозврата = 0;
	
КонецФункции //ОтключитьДиск()

Лог = Логирование.ПолучитьЛог("ktb.app.cpdb");