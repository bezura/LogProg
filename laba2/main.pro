﻿implement main
    open core, stdio, file

domains
    состояние = открыт; закрыт.

class facts - factsDb
    кинотеатр : (integer Id, string Название, string Адрес, string Телефон, integer Количество_мест, состояние Статус) nondeterm.
    кинофильм : (integer Id, string Название, integer Год_выпуска, string Режиссер, string Жанр) nondeterm.
    показывают : (integer Id_кинотеатра, integer Id_фильма, string Дата, string Время, integer Выручка) nondeterm.

class predicates
    адрес_кинотеатра_по_жанру : (string Адрес, string Жанр) nondeterm anyflow.
    кинотеатр_по_фильму : (string Название, string Фильм) nondeterm anyflow.
    адреса_кинотеатров_по_режиссеру_и_жанру : (string Адрес, string Режиссер, string Жанр) nondeterm anyflow.
    адреса_открытых_или_закрытых_кинотеатров : (string Кинотеатр, string Адрес, состояние Статус) nondeterm anyflow.
    фильмы_в_кинотеатре : (string Кинотеатр, integer* Фильмы) nondeterm anyflow.
    длина : (integer*, integer, integer [out]) nondeterm.
    количество_фильмов_автора : (string Режиссер, integer Количество [out]) nondeterm.
    выручка_кинотеатра : (string Название_кинотеатра, integer Общая_выручка [out]) nondeterm.
    сумма_списка : (integer*, integer, integer [out]) nondeterm.
    средняя_выручка_всех_кинотеатров : (integer [out]) nondeterm.

clauses
    длина([_ | Лист], Инкремент, Количество) :-
        длина(Лист, Инкремент + 1, Количество).
    длина([], Количество, Количество).

    сумма_списка([Этот_элемент | Лист], Сумма, Общая_сумма) :-
        Новая_сумма = Сумма + Этот_элемент,
        сумма_списка(Лист, Новая_сумма, Общая_сумма).
    сумма_списка([], Общая_сумма, Общая_сумма).

    адрес_кинотеатра_по_жанру(Адрес, Жанр) :-
        кинотеатр(Id, _, Адрес, _, _, _),
        показывают(Id, ФильмId, _, _, _),
        кинофильм(ФильмId, _, _, _, Жанр).

    кинотеатр_по_фильму(Название, Фильм) :-
        кинотеатр(Id, Название, _, _, _, _),
        показывают(Id, ФильмId, _, _, _),
        кинофильм(ФильмId, Фильм, _, _, _).

    адреса_кинотеатров_по_режиссеру_и_жанру(Адрес, Режиссер, Жанр) :-
        кинотеатр(Id, _, Адрес, _, _, _),
        показывают(Id, ФильмId, _, _, _),
        кинофильм(ФильмId, _, _, Режиссер, Жанр).

    адреса_открытых_или_закрытых_кинотеатров(Кинотеатр, Адрес, Статус) :-
        кинотеатр(_, Кинотеатр, Адрес, _, _, Статус).

    фильмы_в_кинотеатре(Название, Фильмы) :-
        кинотеатр(Id, Название, _, _, _, _),
        Фильмы = [ ФильмId || показывают(Id, ФильмId, _, _, _) ].

    количество_фильмов_автора(Режиссер, Количество) :-
        Фильмы = [ ФильмId || кинофильм(ФильмId, _, _, Режиссер, _) ],
        длина(Фильмы, 0, Количество).

    выручка_кинотеатра(Название_кинотеатра, Общая_выручка) :-
        кинотеатр(Id, Название_кинотеатра, _, _, _, _),
        Выручки = [ Выручка || показывают(Id, _, _, _, Выручка) ],
        сумма_списка(Выручки, 0, Общая_выручка).

    средняя_выручка_всех_кинотеатров(Средняя_выручка) :-
        Выручки =
            [ Выручка ||
                показывают(Id, _, _, _, Выручка),
                кинотеатр(Id, _, _, _, _, _)
            ],
        длина(Выручки, 0, Количество_кинотеатров),
        сумма_списка(Выручки, 0, Общая_выручка),
        Средняя_выручка = math::round(Общая_выручка / Количество_кинотеатров).

clauses
    run() :-
        consult('../facts.txt', factsDb),
        fail.

    run() :-
        адреса_открытых_или_закрытых_кинотеатров(Название, Адрес, открыт),
        write("Кинотеар: ", Название, " По адресу: ", Адрес),
        nl,
        fail.

    run() :-
        nl,
        fail.

    run() :-
        фильмы_в_кинотеатре("Звездный", Фильмы),
        длина(Фильмы, 0, Количество),
        write("Количество фильмов в кинотеатре Звездный: ", Количество),
        nl,
        fail.

    run() :-
        nl,
        fail.

    run() :-
        количество_фильмов_автора("Джордж Лукас", Количество),
        write("Количество фильмов от Режиссера Джордж Лукас: ", Количество),
        nl,
        fail.

    run() :-
        nl,
        fail.

    run() :-
        выручка_кинотеатра("Звездный", Общая_выручка),
        write("Общая выручка в кинотеатре Звездный: ", Общая_выручка),
        nl,
        fail.

    run() :-
        nl,
        fail.

    run() :-
        средняя_выручка_всех_кинотеатров(Средняя_выручка),
        write("Средняя выручка для всех кинотеатров: ", Средняя_выручка),
        nl,
        fail.

    run().

end implement main

goal
    console::runUtf8(main::run).
