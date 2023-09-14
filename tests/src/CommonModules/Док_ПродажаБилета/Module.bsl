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

Процедура ИсполняемыеСценарии() Экспорт
	
	ЮТТесты.ВТранзакции()
		.ДобавитьТест("ОбработкаПроведения")
		.ДобавитьТест("ОбработкаПроверкиЗаполнения")
	;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаПроверкиЗаполнения() Экспорт
	
	Документ = Документы.ПродажаБилета.СоздатьДокумент();
	
	Описание = "Незаполненный документ";
	ЮТест.ОжидаетЧто(Документ.ПроверитьЗаполнение())
		.ЭтоЛожь();
	
	ЮТест.ОжидаетЧто(ПомощникТестирования.Сообщения(Истина), Описание)
		.Содержит("Не введено ни одной строки в список ""Позиции продажи""")
		.Содержит("Поле ""Сумма документа"" не заполнено")
		.Содержит("Поле ""Дата"" не заполнено")
	;
	
КонецПроцедуры

#КонецОбласти
