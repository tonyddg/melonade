#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "C++ 面向对象编程")

#import "/utility/include.typ": *

= C++ 面向对象编程

== 内存模型和名称空间

=== 作用域、链接性、持续性 

C++ 中变量存储的方式通过作用域、链接性、持续性三种属性来解释

*作用域* (Scope)：作用域表明变量的名称在同一源文件内多大的范围内可以使用，一般情况下有以下两种：
- 局部作用域：只能在#hl(2)[同一个代码块中访问]，一般即定义在某个代码块 `{}` 内的局部变量的作用域
- 全局作用域：可以在#hl(2)[同一文件、名称空间、类中访问]，一般即函数或代码块外的全局变量
- 局部与全局存在相同名称的变量时，将优先访问局部变量，但可使用域解析运算符 `::<变量名>` 说明访问的是全局变量

*链接性* (Linkage)：链接性表明变量如何在不同代码块或源文件之间共享变量，一般有以下三种：
- 内部链接性：在#hl(2)[同一个文件中的不同代码块]之间共享变量
- 外部链接性：在#hl(2)[不同文件中共享]变量
- 无链接性：不能共享

*持续性* (Duration)：持续性表明变量值在内存中持续的时间，一般情况下有以下四种：
- 自动存储持续性：在执行变量#hl(2)[所属函数或代码块时创建、执行完成时销毁]
- 静态存储持续性：#hl(2)[在程序启动时创建、程序退出时销毁]
- 线程存储持续性（用于多线性，此处不讨论）、动态存储持续性（通过 new 与 delete 手动控制变量值创建与销毁，此处不讨论）

=== 存储说明符 <sec:storage_symbol>

声明仅需要给出变量的类型与名称，而定义还需要通过赋值运算给出初值。C++ 要求任何变量可以多次声明，但只能定义一次。

C++ 中通过在声明变量时给出存储说明符，可以修改变量默认的存储方式，主要有

#figure(
  table(
    columns: 5,
    align: horizon + left,
    table.header()[*声明方法*][*作用域*][*链接性*][*持续性*][*说明*],
    [代码块中，自动变量], [局部], [无], [自动], [称为局部变量。必须在声明的同时定义],
    [代码块中，`static`], [局部], [无], [静态], [称为静态变量。在代码块第一次执行时定义，后续仅视为声明不执行赋值操作。],
    [文件上，`extern` \ 或自动变量], [全局], [外部], [静态], [
      称为外部变量。不定义将自动使用 0 初值，或只能定义一次，且定义时 `extern` 不是必须的。其他文件中访问则需要用 `extern` 关键字声明。
    ],
    [文件上，`static`], [全局], [内部], [静态], [
      该类型存储说明主要用于将全局变量限制在文件内，与外部链接性的全局变量区分
    ],
  )
)

以上表格适用于变量，对于函数可视为一种变量，但存储说明符有以下区别：
- 函数不能在代码块内定义，因此函数的作用域一定是全局的
- 函数为一种特殊的全局变量，且声明时也可以省略 `extern` 关键字
- 使用 `static` 关键字可以将函数限定为内部链接性，即不能在其他文件中使用该函数
- 内联函数是特例，允许定义多次，但每次定义必须相同

基于以上理论可知：
- 头文件专门中用于存放函数、全局变量的声明，而对应的源文件专门用于定义这些函数、全局变量
- 其他源文件只要引用了头文件给出这些函数、全局变量的声明，就可以从源文件调用这些函数、全局变量的声明

=== 名称空间 <sec:namespace>

名称空间用于将全局作用域下大量变量、函数限定在特定域内，解决名称冲突文件

使用以下方式规定 `{}` 内的代码位于特定名称空间下（名称空间定义不能在代码块内）

```cpp
namespace 名称空间{
  // 声明名称空间下的变量 ...
} 
```

想要访问特定名称空间下变量需要使用域解析运算符 `::` 
- 用 `名称空间::变量` 的方式访问其他名称空间下的变量
- 所有变量都在一个大的全局名称空间下，即可使用域解析运算符 `::<变量名>` 访问可能与局部变量冲突的全局变量
- 允许嵌套的名称空间，同样用域运算符访问子名称空间再访问其中的变量

可以使用 `using` 指令将别的名称空间下的变量添加到当前名称空间或代码块中
- `using <名称空间>::<变量名>;` 将单个变量添加到当前名称空间
- `using namespace <名称空间>;` 将指定名称空间下所有变量添加到当前名称空间
- 如果 `using` 指令导致名称冲突，将会出错

== 类的构造析构与声明周期

=== 类的声明

类通常在头文件中声明，声明时具有以下语法结构

```cpp
class 类名{
  // 成员声明
};
```

注意
- 虽然有花括号但属于声明，因此类在声明最后要有 `;`
- 通过#link(<sec:member>)[类成员的定义]完成类的定义

=== 默认构造函数 <sec:default_construction>

C++ 除了重载构造函数外，会在必要时创建以下三种构造函数 (省略 C11 的移动构造函数)

```cpp
class Example{
    // 默认构造函数
    Example() {...}
    // 拷贝构造函数
    Example(const Example& rhs) {...}
    // 拷贝赋值操作 (严格意义上不属于构造函数)
    Example& operator=(const Example& rhs) {...}
    // 默认析构函数
    ~Example() {...}
};
```

对于这些构造函数，即使没有实现
- 默认构造函数将在没有其他重载构造函数时自动创建
- 拷贝构造函数与拷贝赋值操作将在对应操作出现时自动创建
  - 拷贝构造函数在以下行为调用：使用相同类对象初始化类（包括 `new`）、函数按值传参与返回对象
  - 拷贝赋值操作在以下行为调用：同类对象赋值
- 两种自动创建的构造函数均属于浅拷贝，只是简单地复制成员，当成员中有指针指向动态内存时，将直接复制指针
- 可以通过私有的、以上函数的声明而没有定义阻止这些函数的自动创建

对于单参数的重载构造函数
- 将视为一种隐形的类型转换函数，会在以下情况自动调用转化类型：初始化类、赋值、传参、返回值
- 可使用 `explicit` 禁用这种特性

=== 创建类的语法

创建类时有以下几种语法

```cpp
Example val = Example(...);
Example val(...); // 不推荐, 无参数时可能与函数声明混淆
// 动态持续性
Example* val = new Example(...);
// C11 标准 (推荐, 可以阻止自动类型转换)
Example val = {...};
Example val {...}; // Example val{}; 可用于无参数的情况
```

对于 `()` 与 `{}` 语法对于 STL 容器存在一定差异

```cpp
// {} 理解为容器内的元素，优先匹配以 initializer_list<int> 为参数的构造函数
// 创建单个元素为 10 的数组
auto arr = std::vector<int>{10} 
// () 理解为函数调用，匹配以 size_t 为参数的构造函数
// 创建长度为 10 的数组
auto arr = std::vector<int>(10) 
```

=== 初始化列表 <sec:construction_list>

以下成员、基类必须在初始化列表中定义
- #hl(2)[常量成员、引用成员、没有默认构造函数的成员]
- 没有默认构造函数的基类，如果有#link(<sec:derive>)[虚继承]则包括虚基类的共同父类

初始化顺序
- 初始化顺序只看继承顺序与成员在类定义中的顺序，与#hl(2)[列表顺序无关]，因此建议将列表顺序与实际顺序保持一致
- 具体初始化调用顺序为：#hl(2)[虚基类共同父类、继承列表顺序构造虚基类（排除已构造的共同父类）、继承列表顺序构造一般基类]、成员声明顺序构造成员、执行构造函数函数体
- #hl(2)[虚基类的共同父类一定由最顶层的子类负责构造]，因此即使没有在初始化列表中也会尝试调用默认的虚基类共同父类，且父类中关于虚基类的构造将被忽略

=== 析构函数

析构函数基本规则
- 析构函数的形式固定为 `~T() {...}`，没有返回值
- 析构函数#hl(2)[不能重载、不能有参数、不能是] `static`
- 析构函数将在对象生命周期结束时（离开作用域、`delete`、程序结束等）自动调用
- 涉及继承时，基类必须是#link(<sec:virtual_fun>)[虚函数]，否则子类的析构函数可能无法被调用
- 尽量只用标准库成员（`string`、`vector`、智能指针）管理资源而不要主动编写析构函数

在销毁对象时，销毁顺序与构造函数相反：先执行析构函数体、再按成员声明逆序析构成员、最后析构基类

== 类的封装

=== 类成员的类型与定义 <sec:member>

对于数据成员 (Data Member) 有以下类型
- 一般数据成员
  - 在类内声明，每个对象各一份
  - C11 起可以在声明时通过 `=` 给出默认值
- 常量数据成员
  - 声明同一般数据成员，但是#hl(2)[变量类型前有限定符] `const` 
  - 必须在构造函数初始化列表中初始化，后续不能更改
- 静态数据成员
  - 声明同一般数据成员，但是#hl(2)[变量类型前有限定符] `static`
  - 整个类共享一份，不属于某个对象，通过 `类名::成员名` 访问
  - 必须在源文件中通过 `类型 类名::成员名 = ...;` 声明
  - 可以将 `const` 视为类型一部分，其余规则相同，得到常量静态成员

对于成员函数 (Function Member) 有以下类型
- 一般成员函数
  - 在类内定义、源文件中通过 `类型 类名::函数名(...){}` 声明
  - 函数内可直接访问成员，或通过类型为 `T* const` 的特殊指针 `this` 访问
- 常量成员函数
  - 与定义与声明与一般成员函数类似，但是#hl(2)[函数全名后有限定符] `const`（函数用说明符）例如 #raw("const T& get_val() const;", lang: "cpp")，且定义时也要保留函数说明符
  - 函数内不能修改普通数据成员、只能调用常量成员函数且 `this` 的类型为 `const T* const`
  - 可以由对象常量调用（对象常量不能调用一般成员函数），且可与一般成员函数使用相同签名（重载）
  - 通常作为对象访问管理数据的只读接口
- 静态成员函数
  - 与定义与声明与一般成员函数类似，但是#hl(2)[函数声明的返回值类型前有限定符] `static`
  - 不能访问一般成员与 `this` 指针，只能访问静态成员
  - 通常作为创建对象的工厂函数

声明成员时注意
- 在 C11 及后续的版本中，在数据成员定义时
  - 可以直接在声明时指定一般与常量数据成员的默认值
  - 可以直接在声明时指定静态数据成员的初始值
- 可以直接在类内给出成员函数（与#link(<sec:control_friend>)[友元函数]）的定义，通过这种方式定义的成员函数与友元函数将作为内联函数

例如以下代码给出了以上几种成员的声明与定义

```cpp
// 头文件
class Example {
    int _normal_m;
    const int _const_m;
    static int _static_m;
    static const int _const_static_m;

    int fun();
    int fun() const;
    static int static_fun();

public:
    Example();
    ~Example();
};

// 源文件
int Example::_static_m = 80;
const int Example::_const_static_m = 80;

Example::Example(): _normal_m(0), _const_m(0) {}
Example::~Example() {}

int Example::fun() {return 0;}
int Example::fun() const {return 0;}
int Example::static_fun() {return 0;}

```

=== 函数与运算符重载

函数重载 (Function Overloading)
- 同一作用域内，同名函数可以存在多个版本，靠参数个数与参数类型区分使用哪个版本的函数
- #hl(2)[不能只靠返回值的类型与函数默认参数区分同名函数不同版本]
- 对于#link(<sec:member>)[成员函数]，相同签名的常量成员函数可以参与一般成员函数的重载

运算符重载 (Operator Overloading)
- 运算符重载即定义为 `operator运算符` 的函数，具有成员函数与非成员函数两种形式（一般为#link(<sec:control_friend>)[友元函数]）
  - 成员函数形式：操作符的左操作数必定是本类对象的引用，且在参数列表中省略
  - 非成员函数形式：当需要对称性或左操作数不是本类对象时使用
- 运算符重载操作存在以下限制
  - 以下运算符不能重载：成员访问 `.`；成员指针访问 `.*`；三元条件 `?:`；作用域解析 `::`；对象长度 `sizeof`
  - 以下运算符不能以非成员函数形式重载：赋值运算符 `=`；函数操作运算符 `()`；数组下标运算符 `[]`；对象指针成员访问 `->`
  - 不能创建不存在的运算符，运算符的优先级、参数数量也不能被修改（参数类型一般可以修改，但最好遵循规范）
  - 非成员函数形式应当保证其中一个参数类型为类的对象（否则没有意义 / 或导致原有运算方式被改变均是不允许的）
- 部分运算符重载时存在以下特性
  - 函数调用运算符 `operator()` 允许自定义参数列表，对象变为 #link("https://zh.cppreference.net/cpp/named_req/FunctionObject.html")[FunctionObject]（数组下标运算符 `[]` 仅支持一个参数）
  - 后缀递增或递减运算符（`a++ / a--`）的重载运算符形式为 `operator++(T&, int)`，参数 `int` 用于与前缀的递增或递减运算符区分，参数值始终为 `0`
  // - 一旦提供了 `operator<` 运算符剩余的 `>,>=,<=` 运算符将基于 `<` 自动实现（`std::sort` 同样依赖于该运算符）
  // - 一旦提供了 `operator==` 运算符剩余的 `!=` 运算符将基于 `==` 自动实现
- 类型转换操作运算符
  - 具有形式 `operator T_target()` 的运算符，用于将对象转化为目标类型 `T_target`，其必须是成员函数形式
  - #hl(2)[类型转换操作运算符的返回值为目标类型，且不能在函数名前面指定函数类型]
  - 类似#link(<sec:default_construction>)[构造函数]，可在签名前使用关键字 `explicit` 阻止因参数传递或赋值产生的自动类型转换
  - 由其他类型转为当前类型的类型转换可通过以单个其他类型为参数的构造函数实现

部分运算符重载时，建议遵守以下规范，具体代码#link(<code:reload>)[参见]（其他运算符#link("https://zh.cppreference.net/cpp/language/operators.html?utm_source=chatgpt.com")[参见]）
- 对于将对象写入输出流的操作可使用非成员函数形式实现
- 对于二元算术运算符的标准实现通常基于复合赋值运算实现
- 对于自定义的字符串对象等通常会用到数组下标运算符 `[]`，为了实现原地修改语法会返回 `T&`，同时为了保证常量对象也能正常使用，会额外实现一个常量成员版本返回 `const T&`
- 一般情况下，赋值运算符 `operator=` 的最好基于交换实现

== 类的继承

=== 类的访问控制 <sec:control_friend>

访问说明符用于控制成员能够被什么访问，共有以下三种访问说明符
- `private`：成员只能由#hl(2)[类的成员函数]（包括同一类的其他对象）和#hl(2)[友元类或函数]使用
- `protected`：成员只能由#hl(2)[类及其派生类的成员函数]（强制转换为基类 `Base*(this)` 后不能访问）和#hl(2)[友元类或函数]内使用
- `public`：任意函数均能使用
在类定义中
- 通过 `访问说明符:` 表明它之后声明的所有成员使用该访问方式，直到遇到下一个访问说明符
- `class` 的默认访问说明符为 `private`；`struct` 的默认访问说明符为 `public`
- 访问说明符影响包括数据成员、成员函数、类型成员（`typedef` 与  `using`）、嵌套类、枚举等
- 习惯上定义数据成员为 `private`，接口成员函数为 `public`，扩展点为 `protect`

友元可以用于授予其他类或函数对成员的访问权，而不受访问说明符限制
- 需要在类定义内使用 `friend <友元类 / 函数声明>;` 声明外部的友元类或函数，友元声明不受访问控制符影响
- 除了友元声明外，类或函数最好在类外也进行一次声明
- 友元关系不具备传递性（友元的友元不是友元）也不能被继承

=== 类的继承关系 <sec:derive>

继承关系指的就是“是”这种关系。比如：“学生是人”，那么就可以说学生和人之间是继承关系。从实际学生拥有人的全部特征，而且还可以附带其他信息。

在类声明中使用 `class 类名: 访问说明符1 父类1, 访问说明符2 父类2, ... {}` 体现子类与父类间的继承关系。其中的 `访问说明符` 用于控制子类如何访问继承自父类的成员

以下表格说明#hl(2)[父类的不同类型成员在子类的访问方式]

#table(
  columns: (1fr,) * 4,
  align: horizon + center,
  table.header[*继承方式*][父类 `public` 成员][父类 `protect` 成员][父类 `private` 成员],
  [`public`], [`public`], [`protect`], table.cell(rowspan: 3)[子类不可访问任何父类 `private` 成员],
  [`protected`], [`protect`], [`protect`],
  [`private`], [`private`], [`private`],
)

继承中还有以下注意
- `class` 子类在继承时默认访问说明符为 `private`；`struct` 子类在继承时默认访问说明符为 `public`
- 在子类的 `public` 访问说明符下使用 #link(<sec:namespace>)[using] 语句（如 #raw("public: using B::m;", lang: "cpp")）可以将父类中可访问的且继承后非 `public` 成员提升为 `public`
- 继承的实现方式即在类实例化前先实例化父类，再依据继承访问说明符确定子类如何访问父类成员，因此需要在#link(<sec:construction_list>)[构造函数的初始化列表]中调用父类构造函数
- 构造函数, 构析函数, 复制运算符 `operator=` 不会被派生类继承（但可以是虚函数）
- 私有继承是子类与父类几乎完全隔离因此没有太大意义，此时建议用组合代替继承，将父类对象作为成员

多重继承与虚基类：
- 名称冲突时需要通过域解析运算符 `对象.父类::继承成员` 确定使用哪个父类的成员
- 当存在多个继承时称为多重继承，子类实例化时每个父类（包括父类的基类）都将被创建，当两个父类 `C,B` 具有同一父类 `A` 时（特别是菱形继承），将创建两份类 `A` 的实例
- 虚基类用于解决以上问题，即当#hl(2)[希望与其他分支共享父类时]，可在继承时在继承访问说明符前加上 `virtual` 将父类作为虚基类进行继承
- 此时当父类因为多重继承可能存在多个副本时，这些使用虚继承的子类将使用共享同一个父类实例（非虚基类依然会创建独立地父类实例）
- 虚基类由最底层子类在#link(<sec:construction_list>)[构造函数的初始化列表]中负责初始化，中间父类的初始化将被忽略

例如以下最典型的虚基类应用即 `basic_iostream` 的结构中，虚基类 `base_ios` 仅会被实例化一次

```cpp
class base_ios{...};
class basic_ostream: virtual public base_ios {...};
class basic_istream: virtual public base_ios {...};
class basic_iostream: public basic_ostream, public basic_istream{...};
```

=== 虚函数  <sec:virtual_fun>

虚函数用于赋予对象动态多态性，且需要借助#link(<sec:derive>)[类的继承]发挥作用，即
- 父类指针（或引用）不仅可以指向父类对象，还可以指向任何继承自父类的子类对象
- 默认通过父类指针只能调用父类方法（即使指向子类对象且子类有同名方法）
- 如果父类方法为虚函数且子类有同名方法，将动态地调用子类的同名方法，从而实现多态性
- 虚函数与函数重载类似，但函数重载依据参数列表在编译时确定使用哪个版本，属于静态多态性；虚函数依据指针当前指向的对象类型确定使用哪个版本，述序动态多态性

虚函数的使用
- 虚函数的定义
  - 在基类的函数名前加上关键字 `virtual` 即可表示该函数是虚函数，且继承后依然为虚函数（即使没有关键字）
  - #hl(2)[静态成员函数与函数模板不能是虚函数]，而 `private` 的成员函数与构造函数定义为虚函数没有意义
  - 为了保证对象的正确析构，一般析构函数一定要定义成虚函数
  - 在虚函数声明后加上 `=0;` 表明这是一个不需要定义（但可以有定义）且必须被子类重写的虚函数，此时类变为抽象基类，不能实例化只能被继承
- 虚函数的覆盖条件
  - 子类重写父类虚函数时要求具有相同的函数名、参数列表与限定符（此处仅介绍了#link(<sec:member>)[常量成员函数]）
  - 返回值则要求相同或不同时需要时可以#link("https://cppreference.cn/w/cpp/language/virtual")[协变]的
  - 虚函数将依据调用点（调用虚函数指针类定义中的默认参数）使用默认参数，而不是原始定义，因此不建议在虚函数中使用
- C11 起，可以在虚函数的函数名后加上函数用说明符进一步检查虚函数的行为以增加安全性
  - `override` 表明该虚函数一定重写了基类的某个虚函数，而不是基础的虚函数，否则将出错
  - `final` 表明该虚函数不能再被重写了，如果子类再重写此虚函数将出错

== STL

=== 序列容器

STL 的基本容器具有以下常用的通用方法
- `con.begin() / con.end()` 获取容器的首元素与超尾迭代器
- `con.cbegin() / con.cend()` 获取容器的首元素与超尾的常量迭代器
- `con.size()` 获取容器的元素数量
- `con.operator==` 比较两个容器是否完全相等

其中按顺序存储数据称为*序列容器*，STL 根据存储性能需要提供了以下几种常用序列容器

#align(center)[

#table(
  columns: 7,
  align: center + horizon,
  table.header()[*容器名称*][*底层实现*][*随机访问*][*末尾增删*][*头部增删*][*中间增删\ 复杂度*][*其他说明*],

  [`std::vector`], [连续内存], [$O(1)$], [$gt.approx O(1)$], [不支持], [$O(n)$], [建议作为默认数组容器\ 可使用 `data` 方法获取原始的连续内存],
  [`std::deque`], [分段连续\ 双端队列], [$gt.approx O(1)$], [$O(1)$], [$O(1)$], [$O(n)$], [用于频繁两端增删数据],
  [`std::list`], [双向链表\ 单向链表], [不支持], [$O(1)$], [$O(1)$], [$O(1)$], [用于频繁元素操作，有链表专用的 `merge` 合并、`sort` 排序方法],
)
]

序列容器具有以下通用的方法
- 构造函数 `T arr(n, val)` 创建长度为 `n` 值为 `val` 的序列
- 构造函数 `T arr{val1, ...}` 以给定序列初始化容器
- 插入元素 `arr.insert(it, val)` 在迭代器 `it` 指向的元素后插入 `val`
- 删除元素 `arr.erase(it)` 删除迭代器 `it` 指向的元素
- 随机访问 `a.at(n) / a[n]` 执行 `a.at(n)` 还将检查是否越界
- 末尾增删 `a.push_back(t) / a.pop_back()`；头部增删 `a.push_head(t) / a.pop_head()`

除了以上基本序列容器，还有基于以上容器，用于模拟特定数据结构的*容器适配器*，常用的有（不一定有上述标准方法）
- `std::priority_queue` 优先队列，元素要实现 `>` 运算符，最大元素总在队首
- `std::queue` 模拟队列，`std::stack` 模拟栈
- `std::array` 固定长度数组，无法增删元素
- `std::initializer_list` 用于表示数组常量或函数的边长参数，只能单向迭代遍历（通常用#link(<sec:iterator>)[迭代器 `for` 循环]遍历），具体用法#link(<code:template>)[参见]

=== 关联容器

*关联容器*即一系列不存在顺序关系的容器，默认版本中不允许容器中有重复的键（元素）且键要实现 `>` 运算符，主要包含集合 `std::set` 与映射 `std::map`

关联容器有以下通用方法
- 构造函数 `T con{val1, ...}` 以给定序列作为容器初始键
- 插入键 `con.insert(val)` 返回值为 `std::pair<iterator, bool>` 表示插入位置的迭代器与插入是否成功（多重键的版本仅返回迭代起）
- 删除键 `con.erase(val)` 返回值为 0 或 1，表示实际被删除的键（1 即删除成功，多重键将删除所有相同键）
- 查找键 `con.find(val)` 查找成功时返回迭代器，否则返回 `con.end()`（需要与 `con.end()` 比较判断键是否存在）

映射 `std::map<K, V>` 与集合的区别在于，映射的每个键还能附带一个值，并且能通过键索引值
- 映射的元素为通过 `std::pair<K, V>(key, val)` 对象表示的键值对
- 插入操作中，需要使用 `con.insert(std::pair<K, V>(key, val))` 插入整个键值对
- 可通过 `a.at(n) / a[n]` 查询给定键名对应的键值

除了以上两种，还有以下前缀变体
- `unordered_` 基于哈希表的无序版本，需要支持 `std::hash`，适合快速读取、较少删改的情况
- `multi` 允许重复键版本

=== 容器迭代与算法 <sec:iterator>

STL 为每个容器以嵌套类 `T::iterator` 的方式定义了对应的迭代器。
- 迭代器与指针类似指向容器中的某个元素，可通过取值运算符 `*` 读取对应的元素值，同时同一迭代器指向的元素一定相同
- 与指针不同在于，通过对迭代器定义 `+/-` 运算，可以移动迭代器到下一个元素，连续的 `+/-` 运算可以遍历整个容器
- 容器一定有 `con.begin()` 迭代器指向第一个元素、`con.end()` 迭代器指向末尾元素的下一个保留位置，暗示迭代完成

对于用于一般顺序容器的随机访问迭代器有以下操作
- `iter +/- n` 指向迭代器 `iter` 前 `n` 或后 `n` 个元素
- `++iter / iter++` 移动到下一个迭代器，建议使用 `++iter` 开销最小
- `iterA - iterB` 计算将迭代器 A 移动到 B 需要移动几次（`iter - con.begin()` 可以得到迭代器指向元素的索引）
- `iterA != iterB` 判断两个迭代器是否指向同一元素（`iter != con.end()` 可以判断迭代是否结束）

通过迭代器与 `for` 循环即可完成对容器元素的遍历

```cpp
for(
    // 以起始元素迭代器为起点，缓存终点迭代器
    // 遍历中假设元素没有增删（遍历时增删元素很危险）
    auto iter = con.begin(), end_iter = con.end();
    // 以不等式判断是否到达迭代终点（不建议使用比较）
    iter != end_iter;
    // 使用前置 ++ 效率更高
    ++iter
){
    // ...
}
```

在 C11 中还支持以下快速写法，直接取迭代器指向元素的引用 / 常量引用（同样遍历时最好不要增删元素）

```cpp
for(auto& val: con){...}
for(const auto& val: con){...}
```

=== 智能指针

智能指针基本使用
- 智能指针是一系列来自头文件 `<memory>` 的对象，可以用于管理指针, 防止指针忘记释放与裸指针造成危害。
- 以其封装的指针指向的资源类型为模板，可以像普通指针使用 `->` 运算符访问指向的资源，使用 `*` 运算符直接访问资源
- 利用构析函数，当智能指针生命周期结束将会自动销毁其指向的资源，或使用成员函数 `release()` 可以释放指针对资源的控制权
- 当智能指针管理的资源被销毁时，将其强制转换为 `bool` 类型将得到 `false`，否则为 `true`
- 智能指针以指针为参数的构造函数，为 `explict` 型即不会在赋值操作中隐式转换，且最好使用 `new` 创建资源（智能指针使用 `delete` 销毁资源），例如

```cpp
// 调用构造函数，允许
auto ptr = std::unique_ptr<int>(new int(100)); 
// 赋值以隐式调用构造函数，不允许
std::unique_ptr<int> ptr = new int(100); 
```

独占智能指针 `unique_ptr` 独享指针的资源，只能移动控制权而不可复制指针，适用于管理一般情况
- 创建时，可以将指针地址传入构造函数, 也可以使用静态方法 `make_unique` 创建
- 应使用 `std::move()` 方法转移控制权，如 #raw("unique_ptr<int> ptr2 = std::move(ptr)", lang: "cpp")
- 作为函数参数传递、迭代遍历独占智能指针时需要使用引用的方式传递独占智能指针，例如

```cpp
std::vector<unique_ptr<int> > arr;
// ...
for (const auto& iter : arr)
{
    std::cout << *iter << std::endl; 
}    
```

共享智能指针 `share_ptr` 采用引用计数法, 当指针的管理对象被全部销毁时, 才会销毁资源，适合用于管理希望被共享的数据
- 创建时，可以将指针地址传入构造函数，建议可以使用静态方法 `make_shared` 创建
- 允许共享智能指针相互赋值以及使用 `==` 运算符检查是否指向同一个资源
- 如果两个类可以相互管理，则 `share_ptr` 可能导致循环引用，最好避免该问题

== 其他语法介绍

=== 模板基础

模板本身不是类 / 函数，而是“生成类 / 函数的蓝图”；当模板实参确定后会形成一个特化（specialization），再在需要时被实例化（instantiate）成具体代码。

此处仅介绍模板的基本使用，如果要真正使用模板编程，请参考#link("https://cppreference.cn/w/cpp/language/templates")[官方文档]与元编程相关资料

函数模板与类模板的基本格式如下
```cpp
template<参数类型1 参数名1, ...>
// 类或函数的声明或定义
```

其中
- `template` 的部分本质为声明的一部分，只是一般约定写成两行
- 与函数默认参数类似，模板也可以有默认参数，也需要从后往前给出

模板主要有以下三种参数
- 类型模板参数：参数类型固定为 `typename` 或 `class`，此时模板参数代表某种类型
- 非类型模板参数：参数类型一般为整形 `int, size_t`、枚举或指针，此时模板参数代表对应类型的常量
- 模板模板参数：参数类型为 `template<模板参数列表> class`，此时模板参数代表某种模板类

例如以下代码给出了三种参数的示例

```cpp
template<
    // STL 顺序容器模板
    template<typename, typename> class ContainerT, 
    // 元素类型
    typename T,
    // 容器大小 
    size_t N = 10,
    // 存储方法 
    typename _Alloc = std::allocator<T>
>
ContainerT<T, _Alloc> container_init(){
  ContainerT<T, _Alloc> arr(N);
  return arr;
}
```

模板类与模板函数的定义（简单示例可#link(<code:template>)[参考]）
- 定义模板函数，都需要在定义前加上与声明模板时相同的 `template<模板参数列表>`
- 定义模板类函数、静态成员#hl(2)[访问模板类的名称空间时，要给出模板参数]，因此一般也要给出相同的 `template<模板参数列表>`
- 为了适应模板类，模板类的友元函数通常也是函数模板，有独立的模板参数列表，且不能省略模板参数（模板类内可以省略模板类的模板参数，也可以加上）
- 定义时，可以使用 `template<>` 代替，再将具体的类型带入模板声明再给出定义，实现模板特化，针对具体类型给出特殊定义（允许单独特化成员函数）

例如以下示例代码

```cpp
template<typename T>
T add(const T& a, const T& b){
    return T{a + b};
}

// 将在 add<bool> 使用该版本代码
template<>
bool add(const bool& a, const bool& b){
    return a || b;
}
```

模板实例化
- 具体使用模板时，仅需通过 `类名/函数名<模板参数>` 即可实例化得到所需的类 / 函数
- 除了模板默认参数可以自动填写，编译器还将尝试依据构造函数 / 函数的参数类型自动推导
- 允许函数同时存在以下版本，有调用优先顺序：非模板版本 > 特化版本 > 模板版本

=== 运算符拾遗

#table(
  columns: 4,
  align: horizon,
  table.header()[*符号*][*功能*][*优先级*][*示例*],

  [`sizeof()`], [获取值所占用的空间, 单位为字节], [与逻辑非, 正负号等一元运算符同为第二高优先级], [`sizeof((int)1)` \ 结果为 4],
  [`A ? B : C`], [表达式 A 为真时运行 B 否则运行 C, 表达式 B, C 的结果类型必须相同], [优先级倒数第三 (低于 `<<`, 因此在 `cout` 中最好加括号)], [`1?2:3` \ 结果为 2],
  [`A, B`], [将多个表达式用逗号隔开, 总的结果为最后一个表达式的结果], [优先级最低], [`1,2` \ 结果为 2],
  [`a = B`, `+=`, `*= `], [返回被赋值变量的引用], [优先级倒数第二], [`(a = 1) += 5` \ 结果为 6 （`a` 的引用）],
  [`a++`], [先返回 `&a`，表达式结束后再令 `a` 加一], [最高优先级], [`a++ + a++` \ 结果为 `a*2+1`],

  [`++a`], [令 `a` 加一后返回 `a` 加一后的副本], [仅低于 `a++`], [在对象中建议使用 `++a` 效率最高]
)
- 逗号运算符与赋值结合时，类型符只能出现一次，且逗号分隔的每个赋值表达式都将创建相同类型的变量，如 #raw("size_t i = 0, j = 0;", lang: "cpp")

=== 基本类型

不同类型的变量运算之间存在隐式转换，满足以下规则（转换关系 `->` 为单向的，无法反向隐式转换）

`char,short -> int -> unsigned -> long -> double <- float`  

常用数据类型字节长度为（即 `sizeof()` 运算结果）

#table(
  columns: (1fr,) * 5,
  align: center,
  [变量类型], [`bool, char`], [`short`], [`int, float`], [`long, double`],
  [字节长度], [1], [2], [4], [8]
)

=== 错误与注意事项

- #hl(2)[函数的默认参数只能在声明时给出]，定义时不能再设置默认参数
- 头文件必须使用宏 `#ifndef 头文件名_H`，`#define 头文件名_H`，`#endif` 包裹，保证只会被包含一次

== 代码示例

=== 构造函数、析构函数与运算符重载 <code:reload>

```cpp
#ifndef MYSTRING_H
#define MYSTRING_H

#include <string.h>
#include <algorithm>
#include <iostream>
#include <list>

class MyString {

private:
    char* _str;
    size_t _size;

public:

    // 构造函数与析构函数 (定义所有默认的构造函数与析构函数)
    MyString(size_t s, char black_ch = ' ');
    MyString(const char* obj);
    MyString(const MyString& obj);
    ~MyString();

    // 交换与赋值运算符 (基于交换定义赋值运算符代替自动赋值运算)
    void swap(MyString& obj) noexcept;
    friend void swap(MyString& lhs, MyString& rhs) noexcept;
    MyString& operator=(MyString obj) noexcept;

    // 存储与读取 (数组下标运算符的重载示例)
    char& operator[](size_t index);
    const char& operator[](size_t index) const;
    size_t size() const;

    // 字符串相加 (计算运算符的重载示例)
    void replace(char* obj);
    void add_inplace(const MyString& obj);
    MyString& operator+=(const MyString& obj);
    friend MyString operator+(MyString lhs, const MyString& rhs);

    // 字符串输出 (输入流的重载示例)
    friend std::ostream& operator<<(std::ostream& lhs, const MyString& rhs);
};

MyString::MyString(size_t s, char black_ch): _str(nullptr), _size(s){
    _str = new char[s + 1];
    for(size_t i = 0; i < s; i++){
        _str[i] = black_ch;
    }
    _str[s] = '\0';
}
MyString::MyString(const char* obj): _str(nullptr), _size(strlen(obj)){
    _str = new char[_size + 1];
    strcpy(_str, obj);
}
MyString::MyString(const MyString& obj): _str(nullptr), _size(obj._size){
    _str = new char[_size + 1];
    strcpy(_str, obj._str);
}
MyString::~MyString(){
    delete[] _str;
}

// 先实现类级 swap 基于 std::swap 分别交换每个成员
void MyString::swap(MyString& obj) 
// 函数说明符 noexcept 说明不会抛出异常，让 std::swap 使用更高效的版本
noexcept { 
    // 引入所有可能的 swap 函数到同一名称空间下
    using std::swap;
    // C++ 将自动依据调用对象特化的 swap 函数与 std 的模板 swap 函数
    swap(_str, obj._str);
    swap(_size, obj._size);
}
// 通过按值传递，自动拷贝创建来源对象的临时副本，避免自我赋值问题
MyString& MyString::operator=(MyString obj) 
// 用于调用 void MyString::swap(MyString& obj) noexcept
noexcept { 
    // 使用类级 swap 高效交换两个对象，使 *this 保存的值为来源对象的拷贝
    swap(obj);
    // 临时拷贝 obj 保存的值为被覆盖的旧值在代码退出时自动析构
    return *this;
}
// 统一接口用于代替 std 中的默认 swap 便于用户使用
inline void swap(MyString &lhs, MyString &rhs) noexcept{
    lhs.swap(rhs);
}

// 非只读版本
char& MyString::operator[](size_t index){
    return _str[index];
}
// 只读版本
const char& MyString::operator[](size_t index) const{
    return _str[index];
}
// 成员只读接口
size_t MyString::size() const{
    return _size;
}

// 接管替换资源 (应为 private)
void MyString::replace(char* obj){
    delete[] _str; _str = obj;
    _size = strlen(obj);
}
// 定义自加函数的具体实现
void MyString::add_inplace(const MyString& obj){
    size_t new_size = size() + obj.size();
    auto tmp_str = new char[new_size + 1];
    strcpy(tmp_str, _str);
    strcat(tmp_str, obj._str);
    replace(tmp_str);
}
// 调用对应函数完成加法复合赋值
MyString& MyString::operator+=(const MyString& obj){
    add_inplace(obj);
    // 返回引用以支持链式操作
    return (*this);
}
// 按值传递 lhs 有助于优化链式运算 a + b + c
MyString operator+(MyString lhs, const MyString& rhs){
    lhs += rhs;
    return lhs; // 按值返回结果符合加法定义
}
// 写入后返回以支持链式操作
std::ostream& operator<<(std::ostream& lhs, const MyString& rhs){
    lhs.write(rhs._str, rhs.size());
    return lhs;
}

#endif
```

=== 模板类实现示例 <code:template>

```cpp
template <typename T, size_t n_rows, size_t n_cols>
class MyMatrix{
private:
    std::array<T, n_cols * n_rows> _mat;
public:
    // 构造函数
    MyMatrix(std::initializer_list<std::initializer_list<T> > mat);
    // 模板类内可以省略模板类的模板参数，也可以加上
    MyMatrix(const MyMatrix& obj);

    // 输出流（为了适应模板类，模板类的友元函数通常也是函数模板，有独立的模板参数列表，且不能省略模板参数）
    template <typename T, size_t n_rows, size_t n_cols>
    friend std::ostream& operator<< (std::ostream& lhs, MyMatrix<T, n_rows, n_cols>& rhs);
};

// 模板类的名称空间要给全模板参数，不能只有模板类名
template <typename T, size_t n_rows, size_t n_cols>
MyMatrix<T, n_rows, n_cols>::MyMatrix(std::initializer_list<std::initializer_list<T> > mat){
    size_t cur_row = 0; size_t cur_col = 0;
    // initializer_list 只能单向迭代遍历，不能使用 [] 运算符索引
    for(const auto& rows : mat){
        for(const auto& elem: rows){
            _mat[cur_row * n_cols + cur_col] = elem;
            cur_col += 1;
        }
        cur_row += 1;
        cur_col = 0;
    }
}

template <typename T, size_t n_rows, size_t n_cols>
MyMatrix<T, n_rows, n_cols>::MyMatrix(const MyMatrix<T, n_rows, n_cols>& obj){
    std::copy(obj._mat.begin(), obj._mat.end(), _mat.begin());
}

template <typename T, size_t n_rows, size_t n_cols>
std::ostream& operator<< (std::ostream& lhs, MyMatrix<T, n_rows, n_cols>& rhs){
    for(size_t cur_row = 0; cur_row < n_rows; cur_row++){
        for(size_t cur_col = 0; cur_col < n_cols; cur_col++){
            lhs << rhs._mat[cur_row * n_cols + cur_col] << '\t';
        }
        lhs << std::endl;
    }
    return lhs;
}

// main.cpp
// std::initializer_list 示例
int main() {
    auto a = MyMatrix<int, 3, 3>{
        {0, 1, 2}, {2, 3, 4}, {5, 6, 7}
    };
    std::cout << a;
    return 0;
}

```

=== 虚函数调用规则

```cpp
class A{
public:
    virtual void Print(int a, int b = 100){
        cout << "11 A: a = " << a << ", b = " << b << endl;
    }
};

class B : public A{
public:
    virtual void Print(int a = 4, int b = 5){
        cout << "21 B: a = " << a << ", b = " << b << endl;
    }

    virtual void Print(int a, double d){
        cout << "22 B: a = " << a << ", d = " << d << endl;
    }
};

void Show(A *p){
    p->Print(1);
    p->Print(2, 7.9);
}
void Show(B *p){
    p->Print(3);
    p->Print(4, 3.4);
}

int main(){
    A *pb = new B;
    Show(pb);
    delete pb; return 0;
}
```

对于以上代码的输出结果应为
```text
21 B: a = 1, b = 100
21 B: a = 2, b = 7
```

输出以上结果的原因为
- 指针 `pb` 类型为基类 `A` 因此将调用 `void Show(A*)` 版本的函数
- 调用 `p->Print(1);` 时，将依据虚函数规则调用 `B::print`，但是#hl(2)[默认值 `b` 则是依据调用起点 `A::print` 确定]，因此实际调用为 #raw("p->B::Print(1, 100);", lang: "cpp")
- 调用 `p->Print(2, 7.9);` 时，基类 A 看不到 B 允许第二个参数为浮点数的版本，而是依据虚函数规则调用 `B::print(int, int)`，其中#hl(2)[第二个参数 `7.9` 则转换为整数时将直接截去小数部分]，因此实际调用为 #raw("p->B::Print(2, 7);", lang: "cpp")

=== 数据成员存储规则

```cpp
class C{
public:
    short a;
};

class D : public C{
public:
    short b;
};

void seta(C *data, int index){
    data[index].a = 2;
}

int main(){
    D data[4];
    cout << sizeof(C) << " " << sizeof(D) << endl;

    for(int i = 0; i < 4; ++i){
        data[i].a = 5; data[i].b = 5;
        seta(data, i);
    }

    for(int i = 0; i < 4; ++i){
        cout << data[i].a << data[i].b;
    }

    return 0;
}
```

对于以上代码的输出结果应为
```text
2 4
22225555
```

输出以上结果的原因为
- C++ 中没有虚函数/虚继承时，基类对象通常放在最前面，因此类 `D` 的对象布局通常是：`[C::a (short)] [D::b (short)]`
- 在 seta 里做的是 `data[index]`，但此时 data 的类型是 `C*`，所以 `data + 1` 会前进 `sizeof(C)` 字节，也就是 2 字节，可是真实数组元素间隔是 `sizeof(D)` 字节，也就是 4 字节

// === 常量引用与右值引用