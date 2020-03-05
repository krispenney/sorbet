# typed: true

Hash.new
Hash.new(0)
h = Hash.new {|a, e| a[e] = []}
h[:foo] = :bar

# Bad practise but not a type error
Hash.new([])

# Hash.[] with hash not a type error
Hash[test: 'test']

# to_a and Hash[] play nice together
T.assert_type!(
  Hash[T::Hash[String, String].new.to_a],
  T::Hash[String, String]
)

# defaulting to something of different type should be cool
my_hash = T.let({}, T::Hash[String, String])
T.assert_type!(
  my_hash.fetch("doesnt_exist", 5),
  T.any(String, Integer)
)
T.assert_type!(
  my_hash.fetch("doesnt_exist", "foo"),
  String
)

{a: 1}.merge({b: 2}, {c: 3})


h1 = T::Hash[Integer, String].new
h1[2] = "foo"
h1[nil] = "foo" # error: Expected `Integer` but found `NilClass` for argument `arg0`
h1[3] = nil # error: Expected `String` but found `NilClass` for argument `arg1`

h2 = T::Hash[Integer, String].new("yo")
h2[2] = "foo"
h2[nil] = "foo" # error: Expected `Integer` but found `NilClass` for argument `arg0`
h2[3] = nil # error: Expected `String` but found `NilClass` for argument `arg1`

h3 = T::Hash[Integer, String].new do |h, k|
  T.assert_type!(h, T::Hash[Integer, String])
  T.assert_type!(k, Integer)
  h[k] = "foo"
  h[nil] = "foo" # error: Expected `Integer` but found `NilClass` for argument `arg0`
  h[k] = nil # error: Expected `String` but found `NilClass` for argument `arg1`
end
h3[2] = "foo"
h3[nil] = "foo" # error: Expected `Integer` but found `NilClass` for argument `arg0`
h3[3] = nil # error: Expected `String` but found `NilClass` for argument `arg1`

initial_hash = T.let({ a: 1.0, b: 3.0 }, T::Hash[Symbol, Float])
transformed_hash = initial_hash.transform_values(&:to_s)
T.assert_type!(transformed_hash, T::Hash[Symbol, String])
initial_hash.transform_values(&:size) # error: Method `size` does not exist on `Float`
initial_hash.transform_values.with_index do |v, i|
  T.assert_type!(v, Float)
  T.assert_type!(i, Integer)
end
