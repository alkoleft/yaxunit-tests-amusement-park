//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2023 BIA-Technologies Limited Liability Company
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//©///////////////////////////////////////////////////////////////////////////©//

#Область СлужебныйПрограммныйИнтерфейс

// ЗагрузитьТесты
// 	Читает наборы тестов (тестовые модули) из расширений
// Параметры:
//  ПараметрыЗапускаТестов - см. ЮТФабрика.ПараметрыЗапуска
// 
// Возвращаемое значение:
//  Массив из см. ЮТФабрика.ОписаниеТестовогоМодуля - Набор описаний тестовых модулей, которые содержат информацию о запускаемых тестах
Функция ЗагрузитьТесты(ПараметрыЗапускаТестов) Экспорт
	
	Результат = Новый Массив;
	
	ЮТФильтрация.УстановитьКонтекст(ПараметрыЗапускаТестов);
	
	Для Каждого МетаданныеМодуля Из ТестовыеМодули() Цикл
		
		ОписаниеТестовогоМодуля = ТестовыеНаборыМодуля(МетаданныеМодуля, ПараметрыЗапускаТестов);
		
		Если ОписаниеТестовогоМодуля = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Результат.Добавить(ОписаниеТестовогоМодуля);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// ПрочитатьНаборТестов
// 	Читает набор тестов из модуля 
// Параметры:
//  МетаданныеМодуля - см. ЮТФабрика.ОписаниеМодуля
// 
// Возвращаемое значение:
//  - Неопределено - Если это не тестовый модуль
//  - см. ЮТФабрика.ОписаниеТестовогоМодуля
Функция ИсполняемыеСценарииМодуля(МетаданныеМодуля) Экспорт
	
	ЭтоТестовыйМодуль = Истина;
	ОписаниеТестовогоМодуля = ЮТФабрика.ОписаниеТестовогоМодуля(МетаданныеМодуля, Новый Массив);
	
	ЮТТесты.ПередЧтениемСценариевМодуля(МетаданныеМодуля);
	
	ПолноеИмяМетода = МетаданныеМодуля.Имя + "." + ИмяМетодаСценариев();
	Ошибка = ЮТОбщий.ВыполнитьМетод(ПолноеИмяМетода);
	
	Если Ошибка <> Неопределено Тогда
		
		ТипыОшибок = ЮТФабрика.ТипыОшибок();
		ТипОшибки = ЮТРегистрацияОшибок.ТипОшибки(Ошибка, ПолноеИмяМетода);
		
		Если ТипОшибки = ТипыОшибок.ТестНеРеализован Тогда
			ЭтоТестовыйМодуль = Ложь;
			Ошибка = Неопределено;
		ИначеЕсли ТипОшибки = ТипыОшибок.МалоПараметров Тогда
			Ошибка = ЮТОбщий.ВыполнитьМетод(ПолноеИмяМетода, ЮТОбщий.ЗначениеВМассиве(Неопределено));
			ЮТОбщий.СообщитьПользователю("Используется устаревшая сигнатура метода `ИсполняемыеСценарии`, метод не должен принимать параметров.");
		КонецЕсли;
		
	КонецЕсли;
	
	Если Ошибка <> Неопределено Тогда
		
		НаборПоУмолчанию = ЮТФабрика.ОписаниеТестовогоНабора(МетаданныеМодуля.Имя);
		ЮТРегистрацияОшибок.ЗарегистрироватьОшибкуЧтенияТестов(НаборПоУмолчанию, "Ошибка формирования списка тестовых методов", Ошибка);
		ОписаниеТестовогоМодуля.НаборыТестов.Добавить(НаборПоУмолчанию);
		
	ИначеЕсли ЭтоТестовыйМодуль Тогда
		
		ЮТТесты.ПослеЧтенияСценариевМодуля();
		Сценарии = ЮТТесты.СценарииМодуля();
		
		УдалитьНастройкиМодуляИзПервогоНабора(Сценарии); // TODO Нужен рефакторинг
		
		ОписаниеТестовогоМодуля.НаборыТестов = ЮТФильтрация.ОтфильтроватьТестовыеНаборы(Сценарии.ТестовыеНаборы, МетаданныеМодуля);
		ОписаниеТестовогоМодуля.НастройкиВыполнения = Сценарии.НастройкиВыполнения;
		
	Иначе
		
		ОписаниеТестовогоМодуля = Неопределено;
		
	КонецЕсли;
	
	Возврат ОписаниеТестовогоМодуля;
	
КонецФункции

// ЭтоТестовыйМодуль
//   Проверяет, является ли модуль модулем с тестами
// Параметры:
//  МетаданныеМодуля - Структура - Описание метаданных модуля, см. ЮТФабрика.ОписаниеМодуля
// 
// Возвращаемое значение:
//  Булево - Этот модуль содержит тесты
Функция ЭтоТестовыйМодуль(МетаданныеМодуля) Экспорт

	Если МетаданныеМодуля.Глобальный Тогда
		Возврат Ложь;
	КонецЕсли;

#Если Сервер Тогда
	Возврат ЮТОбщий.МетодМодуляСуществует(МетаданныеМодуля.Имя, ИмяМетодаСценариев());
#КонецЕсли
	
#Если ТолстыйКлиентУправляемоеПриложение ИЛИ ТонкийКлиент Тогда
	Если МетаданныеМодуля.КлиентУправляемоеПриложение Тогда
		Возврат ЮТОбщий.МетодМодуляСуществует(МетаданныеМодуля.Имя, ИмяМетодаСценариев());
	КонецЕсли;
#КонецЕсли
	
#Если ТолстыйКлиентОбычноеПриложение Тогда
	Если МетаданныеМодуля.КлиентОбычноеПриложение Тогда
		Возврат ЮТОбщий.МетодМодуляСуществует(МетаданныеМодуля.Имя, ИмяМетодаСценариев());
	КонецЕсли;
#КонецЕсли
	
	Если МетаданныеМодуля.Сервер Тогда
		Возврат ЮТЧитательСервер.ЭтоТестовыйМодуль(МетаданныеМодуля);
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИмяМетодаСценариев()
	
	Возврат "ИсполняемыеСценарии";
	
КонецФункции

// ТестовыеМодули
//  Возвращает описания модулей, содержащих тесты
// Возвращаемое значение:
//  Массив из см. ЮТМетаданныеСервер.МетаданныеМодуля - Тестовые модули
Функция ТестовыеМодули()
	
	ТестовыеМодули = Новый Массив;
	
	МодулиРасширения = ЮТМетаданныеСервер.МодулиРасширений();
	
	Для Каждого ОписаниеМодуля Из МодулиРасширения Цикл
		
		Если ЮТФильтрация.ЭтоПодходящийМодуль(ОписаниеМодуля) И ЭтоТестовыйМодуль(ОписаниеМодуля) Тогда
			
			ТестовыеМодули.Добавить(ОписаниеМодуля);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТестовыеМодули;
	
КонецФункции

Функция ТестовыеНаборыМодуля(МетаданныеМодуля, ПараметрыЗапуска)
	
	// TODO Фильтрация по путям
	ОписаниеМодуля = Неопределено;
	
#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
	Если МетаданныеМодуля.КлиентОбычноеПриложение ИЛИ МетаданныеМодуля.КлиентУправляемоеПриложение Тогда
		
		ОписаниеМодуля = ИсполняемыеСценарииМодуля(МетаданныеМодуля);
		
	ИначеЕсли МетаданныеМодуля.Сервер Тогда
		
		ОписаниеМодуля = ЮТЧитательСервер.ИсполняемыеСценарииМодуля(МетаданныеМодуля);
		ЮТЛогирование.ВывестиСерверныеСообщения();
		
	КонецЕсли;
#ИначеЕсли Сервер Тогда
	Если МетаданныеМодуля.Сервер Тогда
		
		ОписаниеМодуля = ИсполняемыеСценарииМодуля(МетаданныеМодуля);
		
	Иначе
		
		ВызватьИсключение "Чтение списка тестов модуля в недоступном контексте";
		
	КонецЕсли;
#ИначеЕсли Клиент Тогда
	Если МетаданныеМодуля.КлиентУправляемоеПриложение Тогда
		
		ОписаниеМодуля = ИсполняемыеСценарииМодуля(МетаданныеМодуля);
		
	ИначеЕсли МетаданныеМодуля.Сервер Тогда
		
		ОписаниеМодуля = ЮТЧитательСервер.ИсполняемыеСценарииМодуля(МетаданныеМодуля);
		ЮТЛогирование.ВывестиСерверныеСообщения();
		
	КонецЕсли;
#КонецЕсли
	
	Возврат ОписаниеМодуля;
	
КонецФункции

Функция Фильтр(ПараметрыЗапуска)
	
	Фильтр = Новый Структура("Расширения, Модули, Наборы, Теги, Контексты, Пути");
	
	Фильтр.Расширения = ЮТОбщий.ЗначениеСтруктуры(ПараметрыЗапуска.filter, "extensions");
	Фильтр.Модули = ЮТОбщий.ЗначениеСтруктуры(ПараметрыЗапуска.filter, "modules");
	Фильтр.Теги = ЮТОбщий.ЗначениеСтруктуры(ПараметрыЗапуска.filter, "tags");
	Фильтр.Контексты = ЮТОбщий.ЗначениеСтруктуры(ПараметрыЗапуска.filter, "contexts");
	// TODO: Подумать в каком формате задать наборы - ИмяМодуля.Набор, Набор или другой вариант
	Фильтр.Наборы = ЮТОбщий.ЗначениеСтруктуры(ПараметрыЗапуска.filter, "suites");
	
	// TODO: Обработка путей в формате: Модуль.ИмяТеста, ИмяТеста - метод, параметры, контекст
	// ОМ_ЮТУтверждения.Что[0: 1].Сервер, ОМ_ЮТУтверждения.Что[1: Структура].Сервер
	Фильтр.Пути = ЮТОбщий.ЗначениеСтруктуры(ПараметрыЗапуска.filter, "paths");
	
	Возврат Фильтр;
	
КонецФункции

Процедура УдалитьНастройкиМодуляИзПервогоНабора(СценарииМодуля)
	
	НастройкиВыполнения = ЮТОбщий.СкопироватьРекурсивно(СценарииМодуля.НастройкиВыполнения);
	
	СценарииМодуля.НастройкиВыполнения.Очистить();
	
	СценарииМодуля.НастройкиВыполнения = НастройкиВыполнения;
	
КонецПроцедуры

#КонецОбласти
