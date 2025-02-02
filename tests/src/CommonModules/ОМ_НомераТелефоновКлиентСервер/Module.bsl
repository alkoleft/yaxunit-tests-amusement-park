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
	
	ЮТТесты
		.ДобавитьТест("НормализованныйНомерТелефона")
		.ДобавитьТест("НормализованныйНомерТелефона_Варианты")
		.ДобавитьТест("НормализованныйНомерТелефона_Параметризированный")
			.СПараметрами("71234567890", "Нормализованный номер")
			.СПараметрами("+7 (123) 456-78-90", "Международный формат")
			.СПараметрами("8 (123) 456-78-90", "Через восьмерку")
			.СПараметрами("7 (123) 456-78-90", "Без плюса")
	;
	
КонецПроцедуры

Процедура НормализованныйНомерТелефона() Экспорт
	
	Номер = "+7(123)456-78 90";
	
	Результат = НомераТелефоновКлиентСервер.НормализованныйНомерТелефона(Номер);
	
	ЮТест.ОжидаетЧто(Результат)
		.ИмеетТип("Строка")
		.ИмеетДлину(11)
		.НачинаетсяС("7")
		.НеСодержит(" ")
		.НеСодержит("(")
		.СодержитСтрокуПоШаблону("\d+")
		.НеСодержитСтрокуПоШаблону("\D")
		.Равно("71234567890")
	;
	
КонецПроцедуры

Процедура НормализованныйНомерТелефона_Варианты() Экспорт
	
	Варианты = ЮТест.Варианты("ВходнойНомер, Описание")
		.Добавить("71234567890", "Нормализованный номер")
		.Добавить("+7 (123) 456-78-90", "Международный формат")
		.Добавить("8 (123) 456-78-90", "Через восьмерку")
		.Добавить("7 (123) 456-78-90", "Без плюса")
	;
	
	Для Каждого Вариант Из Варианты.СписокВариантов() Цикл
		Результат = НомераТелефоновКлиентСервер.НормализованныйНомерТелефона(Вариант.ВходнойНомер);
		ЮТест.ОжидаетЧто(Результат, Вариант.Описание)
			.ИмеетТип("Строка")
			.ИмеетДлину(11)
			.НачинаетсяС("7")
			.НеСодержит(" ")
			.НеСодержит("(")
			.СодержитСтрокуПоШаблону("\d+")
			.НеСодержитСтрокуПоШаблону("\D")
			.Равно("71234567890")
		;
	КонецЦикла;
	
	
КонецПроцедуры

Процедура НормализованныйНомерТелефона_Параметризированный(ВходнойНомер, Описание) Экспорт
	
	Результат = НомераТелефоновКлиентСервер.НормализованныйНомерТелефона(ВходнойНомер);
	ЮТест.ОжидаетЧто(Результат, Описание)
		.ИмеетТип("Строка")
		.ИмеетДлину(11)
		.НачинаетсяС("7")
		.НеСодержит(" ")
		.НеСодержит("(")
		.СодержитСтрокуПоШаблону("\d+")
		.НеСодержитСтрокуПоШаблону("\D")
		.Равно("71234567890")
	;
	
КонецПроцедуры

#КонецОбласти
