# classes for representing propositional formulas

class Formula():
    def __init__(self, *args):
        self.args = args

    def __str__(self):
        return self.__class__.__name__ + '(' + ', '.join(map(str, self.args)) + ')'

    def __repr__(self):
        return str(self)

    def __eq__(self, other):
        return isinstance(other, self.__class__) and self.args == other.args

    def __hash__(self):
        return hash(self.__class__.__name__) ^ hash(self.args)

class Var(Formula):
    def __init__(self, name):
        self.name = name

    def __str__(self):
        return self.name

    def __repr__(self):
        return str(self)

    def __eq__(self, other):
        return isinstance(other, self.__class__) and self.name == other.name

    def __hash__(self):
        return hash(self.__class__.__name__) ^ hash(self.name)

class Const(Formula):
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return str(self.value)

    def __repr__(self):
        return str(self)

    def __eq__(self, other):
        return isinstance(other, self.__class__) and self.value == other.value

    def __hash__(self):
        return hash(self.__class__.__name__) ^ hash(self.value)

class Neg(Formula):
    def __init__(self, arg):
        self.arg = arg

    def __str__(self):
        return '~' + str(self.arg)

    def __repr__(self):
        return str(self)

    def __eq__(self, other):
        return isinstance(other, self.__class__) and self.arg == other.arg

    def __hash__(self):
        return hash(self.__class__.__name__) ^ hash(self.arg)

class And(Formula):
    def __init__(self, arg1, arg2):
        self.arg1 = arg1
        self.arg2 = arg2

    def __str__(self):
        return '(' + str(self.arg1) + ' & ' + str(self.arg2) + ')'

    def __repr__(self):
        return str(self)

    def __eq__(self, other):
        return isinstance(other, self.__class__) and self.arg1 == other.arg1 and self.arg2 == other.arg2

    def __hash__(self):
        return hash(self.__class__.__name__) ^ hash(self.arg1) ^ hash(self.arg2)

class Or(Formula):
    def __init__(self, arg1, arg2):
        self.arg1 = arg1
        self.arg2 = arg2

    def __str__(self):
        return '(' + str(self.arg1) + ' | ' + str(self.arg2) + ')'

    def __repr__(self):
        return str(self)

    def __eq__(self, other):
        return isinstance(other, self.__class__) and self.arg1 == other.arg1 and self.arg2 == other.arg2

    def __hash__(self):
        return hash(self.__class__.__name__) ^ hash(self.arg1) ^ hash(self.arg2)

class Imp(Formula):
    def __init__(self, arg1, arg2):
        self.arg1 = arg1
        self.arg2 = arg2

    def __str__(self):
        return '(' + str(self.arg1) + ' -> ' + str(self.arg2) + ')'

    def __repr__(self):
        return str(self)

    def __eq__(self, other):
        return isinstance(other, self.__class__) and self.arg1 == other.arg1 and self.arg2 == other.arg2

    def __hash__(self):
        return hash(self.__class__.__name__) ^ hash(self.arg1) ^ hash(self.arg2)

if __name__ == '__main__':
    a = Var('a')
    b = Var('b')
    c = Var('c')
    d = Var('d')
    e = Var('e')
    f = Var('f')
    g = Var('g')
    h = Var('h')
    i = Var('i')
    j = Var('j')
    k = Var('k')
    l = Var('l')
    m = Var('m')
    n = Var('n')
    o = Var('o')
    p = Var('p')
    q = Var('q')
    r = Var('r')
    s = Var('s')
    t = Var('t')
    u = Var('u')
    v = Var('v')
    w = Var('w')
    x = Var('x')
    y = Var('y')
    z = Var('z')

    print(a)
    print(b)
    print(c)
    print(d)
    print(e)
    print(f)
    print(g)
    print(h)
    print(i)
    print(j)
    print(k)
    print(l)
    print(m)
    print(n)
    print(o)
    print(p)
    print(q)
    print(r)
    print(s)
    print(t)
    print(u)
    print(v)
    print(w)
    print(x)
    print(y)
    print(z)

    print(Neg(a))
    print(Neg(b))
    print(Neg(c))
    print(Neg(d))
    print(Neg(e))
    print(Neg(f))
    print(Neg(g))
    print(Neg(h))
    print(Neg(i))
    print(Neg(j))
    print(Neg(k))
    print(Neg(l))
    print(Neg(m))
    print(Neg(n))
    print(Neg(o))
    print(Neg(p))
    print(Neg(q))
    print(Neg(r))
    print(Neg(s))
    print(Neg(t))
    print(Neg(u))
    print(Neg(v))
    print(Neg(w))
    print(Neg(x))
    print(Neg(y))
    print(Neg(z))

    print(And(a, b))
    print(And(c, d))
    print(And(e, f))
    print(And(g, h))
    print(And(i, j))
    print(And(k, l))
    print(And(m, n))
    print(And(o, p))
    print(And(q, r))
    print(And(s, t))
    print(And(u, v))
    print(And(w, x))
    print(And(y, z))

    print(Or(a, b))
    print(Or(c, d))
    print(Or(e, f))
    print(Or(g, h))
    print(Or(i, j))
    print(Or(k, l))
    print(Or(m, n))
    print(Or(o, p))
    print(Or(q, r))
    print(Or(s, t))
    print(Or(u, v))
    print(Or(w, x))
    print(Or(y, z))

    print(Imp(a, b))
    print(Imp(c, d))
    print(Imp(e, f))
    print(Imp(g, h))
    print(Imp(i, j))
    print(Imp(k, l))
    print(Imp(m, n))
    print(Imp(o, p))
    print(Imp(q, r))
    print(Imp(s, t))
    print(Imp(u, v))
    print(Imp(w, x))
    print(Imp(y, z))
