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

#Область ПрограммныйИнтерфейс

Функция ПродажаБилета(Количество = Неопределено, Номенклатура = Неопределено) Экспорт
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта(Документы.ПродажаБилета);
	Конструктор.ФикцияОбязательныхПолей();
	
	Конструктор.ТабличнаяЧасть("ПозицииПродажи")
		.ДобавитьСтроку();
	
	Если Номенклатура = Неопределено Тогда
		Конструктор.Установить("Номенклатура", Номенклатура());
	Иначе
		Конструктор.Установить("Номенклатура", Номенклатура);
	КонецЕсли;
	
	Если Количество = Неопределено Тогда
		Конструктор.Фикция("Количество");
	Иначе
		Конструктор.Установить("Количество", Количество);
	КонецЕсли;
	
	Конструктор.Фикция("Цена");
	Конструктор.Установить("Сумма", Конструктор.ДанныеСтроки().Цена + Конструктор.ДанныеСтроки().Количество());
	
	Возврат Конструктор.Провести();
	
КонецФункции

Функция Номенклатура(КоличествоПосещений = Неопределено, ВидАттракциона = Неопределено, ВидНоменклатуры = Неопределено) Экспорт
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта(Справочники.Номенклатура);
	
	Если ВидНоменклатуры <> Неопределено Тогда
		Конструктор.Установить("ВидНоменклатуры", ВидНоменклатуры);
	Иначе
		Конструктор.Фикция("ВидНоменклатуры");
	КонецЕсли;
	
	Если ВидАттракциона <> Неопределено Тогда
		Конструктор.Установить("ВидАттракциона", ВидАттракциона);
	Иначе
		Конструктор.Фикция("ВидАттракциона");
	КонецЕсли;
	
	Если КоличествоПосещений <> Неопределено Тогда
		Конструктор.Установить("КоличествоПосещений", КоличествоПосещений);
	Иначе
		Конструктор.Фикция("КоличествоПосещений");
	КонецЕсли;
	
	Конструктор.ФикцияОбязательныхПолей();
	
	Возврат Конструктор.Записать();
	
КонецФункции

Функция Аттракцион(ВидАттракциона = Неопределено) Экспорт
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта(Справочники.Аттракционы);
	
	Если ВидАттракциона <> Неопределено Тогда
		Конструктор.Установить("ВидАттракциона", ВидАттракциона);
	Иначе
		Конструктор.Фикция("ВидАттракциона");
	КонецЕсли;
	
	Конструктор.ФикцияОбязательныхПолей();
	
	Возврат Конструктор.Записать();
	
КонецФункции

Функция Сообщения(Удалять) Экспорт
	
	Сообщения = ПолучитьСообщенияПользователю(Удалять);
	Возврат ЮТОбщий.ВыгрузитьЗначения(Сообщения, "Текст");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
