-- vim:set foldmethod=marker:
local luasnip = require 'luasnip'
local snippet = luasnip.snippet
local text_node = luasnip.text_node
local insert_node = luasnip.insert_node
local function_node = luasnip.function_node
local lambda_node = require 'luasnip.extras'.lambda
local choice_node = luasnip.choice_node
local repeat_node = require 'luasnip.extras'.rep

-- class {{{
local class_snippet = snippet(
  { trig = 'cla', name = 'PHP Class', dscr = "Mike's class with namespace" },
  {
  text_node({
    '<?php',
    '',
    'declare(strict_types=1);',
    '',
    '',
  }),
  function_node(function(_, snip)
    local namespace = string.gsub(snip.env.TM_FILEPATH, '/' .. snip.env.TM_FILENAME, '')
    namespace = string.gsub(namespace, vim.api.nvim_exec('pwd', true), '')
    -- TODO: get SUPER fancy with this and use jq to parse composer.json autoload psr-4, then map that to replacing paths
    namespace = string.gsub(namespace, '/app', 'Palette')
    namespace = string.gsub(namespace, '/', '\\')

    return 'namespace ' .. namespace .. ';'
  end, {}),
  text_node({ '', '', '' }),
  function_node(function(_, snip)
    local class_name = string.gsub(snip.env.TM_FILENAME, '.php', '')

    return 'final class ' .. class_name
  end, {}),
  text_node({ '', '{', '    ' }),
  insert_node(0),
  text_node({ '', '}' }),
}
)
-- }}}

-- artisan command {{{
local artisan_snippet = snippet(
  { trig = 'art', name = 'Laravel artisan command', dscr = "Laravel artisan command with namespace" },
  {
  text_node({
    '<?php',
    '',
    'declare(strict_types=1);',
    '',
    '',
  }),
  function_node(function(_, snip)
    local namespace = string.gsub(snip.env.TM_FILEPATH, '/' .. snip.env.TM_FILENAME, '')
    namespace = string.gsub(namespace, vim.api.nvim_exec('pwd', true), '')
    -- TODO: get SUPER fancy with this and use jq to parse composer.json autoload psr-4, then map that to replacing paths
    namespace = string.gsub(namespace, '/app', 'Palette')
    namespace = string.gsub(namespace, '/', '\\')

    return 'namespace ' .. namespace .. ';'
  end, {}),
  text_node({ '', '', '' }),
  text_node({ 'use Illuminate\\Console\\Command;' }),
  text_node({ '', '', '' }),
  function_node(function(_, snip)
    local class_name = string.gsub(snip.env.TM_FILENAME, '.php', '')

    return 'class ' .. class_name .. ' extends Command'
  end, {}),
  text_node({ '', '{', '    ' }),
  text_node({ '/** @inheritDoc */', '    protected $signature = \'' }),
  insert_node(1, 'one-timers:do-something'),
  text_node({ ' {--dry-run}\';', '', '' }),
  text_node({ '    /** @inheritDoc */', '    protected $description = \'' }),
  insert_node(2, 'Does something'),
  text_node({ '\';', '', '' }),
  text_node({ '    /** @inheritDoc */', '' }),
  text_node({ '    public function handle()', '    {', '' }),
  text_node({ '        if ($this->option(\'dry-run\')) {', '            $this->info(\'Dry run only, no changes will be made\');', '        }', '', '' }),
  text_node({ '        '}),
  insert_node(3),
  text_node({ '', '    }' }),
  text_node({ '', '}' }),
}
)
-- }}}

-- interface {{{
local interface_snippet = snippet(
  { trig = 'inte', name = 'PHP Interface', dscr = "Mike's interface with namespace" },
  {
  text_node({
    '<?php',
    '',
    'declare(strict_types=1);',
    '',
    '',
  }),
  function_node(function(_, snip)
    local namespace = string.gsub(snip.env.TM_FILEPATH, '/' .. snip.env.TM_FILENAME, '')
    namespace = string.gsub(namespace, vim.api.nvim_exec('pwd', true), '')
    -- TODO: get SUPER fancy with this and use jq to parse composer.json autoload psr-4, then map that to replacing paths
    namespace = string.gsub(namespace, '/app', 'Palette')
    namespace = string.gsub(namespace, '/', '\\')

    return 'namespace ' .. namespace .. ';'
  end, {}),
  text_node({ '', '', '' }),
  function_node(function(_, snip)
    local interface_name = string.gsub(snip.env.TM_FILENAME, '.php', '')

    return 'interface ' .. interface_name
  end, {}),
  text_node({ '', '{', '    ' }),
  insert_node(0),
  text_node({ '', '}' }),
}
)
-- }}}

-- phpspec class {{{
local phpspec_class_snippet = snippet(
  { trig = 'pscla', name = 'PhpSpec Class', dscr = "Mike's phpspec class with namespace" },
  {
  text_node({
    '<?php',
    '',
    'declare(strict_types=1);',
    '',
    '',
  }),
  function_node(function(_, snip)
    local namespace = string.gsub(snip.env.TM_FILEPATH, '/' .. snip.env.TM_FILENAME, '')
    namespace = string.gsub(namespace, vim.api.nvim_exec('pwd', true), '')
    -- TODO: get SUPER fancy with this and use jq to parse composer.json autoload psr-4, then map that to replacing paths
    namespace = string.gsub(namespace, '/spec', 'spec\\Palette')
    namespace = string.gsub(namespace, '/', '\\')

    return 'namespace ' .. namespace .. ';'
  end, {}),
  text_node({ '', '', 'use PhpSpec\\ObjectBehavior;', 'use Prophecy\\Argument;', '', '/**', ' * {@inheritDoc}', ' *', ' * ' }),
  function_node(function(_, snip)
    local class_under_test = string.gsub(snip.env.TM_FILEPATH, 'Spec.php', '')
    class_under_test = string.gsub(class_under_test, vim.api.nvim_exec('pwd', true), '')
    class_under_test = string.gsub(class_under_test, '/spec', 'Palette')
    class_under_test = string.gsub(class_under_test, '/', '\\')

    return '@see \\' .. class_under_test
  end, {}),
  text_node({ '', ' */', '' }),
  function_node(function(_, snip)
    local class_name = string.gsub(snip.env.TM_FILENAME, '.php', '')

    return 'final class ' .. class_name .. ' extends ObjectBehavior'
  end, {}),
  text_node({ '', '{' }),
  text_node({ '', '    public function it_is_initializable(): void' }),
  text_node({ '', '    {' }),
  function_node(function(_, snip)
    local class_under_test = string.gsub(snip.env.TM_FILEPATH, 'Spec.php', '')
    class_under_test = string.gsub(class_under_test, vim.api.nvim_exec('pwd', true), '')
    class_under_test = string.gsub(class_under_test, '/spec', 'Palette')
    class_under_test = string.gsub(class_under_test, '/', '\\')

    return { '', "        $this->shouldHaveType('" .. class_under_test .. "');" }
  end, {}),
  text_node({ '', '    }' }),
  insert_node(0),
  text_node({ '', '}' }),
}
)
-- }}}

-- phpspec method {{{
local phpspec_method_snippet = luasnip.parser.parse_snippet(
  { trig = 'psmeth', name = 'PhpSpec Method' },
  [[

public function it_${1:does_something}($2): void
{
    $3
}]]
)
-- }}}

local strict_types_snippet = snippet({ trig = 'dst', name = 'Strict Types' }, { text_node({ '', 'declare(strict_types=1);' }) })
local inherit_doc_snippet = snippet({ trig = 'id', name = 'Inherit Doc' }, { text_node({ '', '/** @inheritDoc */' }) })
local palette_log_snippet = luasnip.parser.parse_snippet({ trig = 'plg', name = 'Palette Log' }, '\\Log::debug("$1");')
local legacy_log_snippet = luasnip.parser.parse_snippet({ trig = 'llg', name = 'Legacy Log' }, '\\Zend_Registry::get("file_logger")->debug("$1");')
local zed_log_snippet = luasnip.parser.parse_snippet({ trig = 'zlg', name = 'Zed Log' }, '\\PalShared_Log::log("$1", "exception.log");')

-- assign {{{
local assign_snippet = snippet({ trig = 'asn', name = 'Assign Class Property' }, {
  text_node('$this->'),
  insert_node(1, 'prop'),
  text_node(' = $'),
  repeat_node(1),
  text_node(';'),
})
-- }}}

-- arg {{{
local argument_snippet = snippet({ trig = 'arg', name = 'Function Argument' }, {
  text_node(''),
  insert_node(1, 'MyClass'),
  text_node(' $'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 1),
})
-- }}}

-- var {{{
local class_var_snippet = snippet({ trig = 'va', name = 'Class Property' }, {
  choice_node(1, {
    text_node('private'),
    text_node('protected'),
    text_node('public'),
  }),
  text_node(' '),
  insert_node(2, 'MyClass'),
  text_node(' $'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 2),
  text_node({ ';' }),
})
-- }}}

-- const {{{
local constant_snippet = snippet({ trig = 'cnst', name = 'Constant' }, {
  choice_node(1, {
    text_node('private'),
    text_node('protected'),
    text_node('public'),
  }),
  text_node(' const '),
  insert_node(2, 'MY_CONST'),
  text_node(' = '),
  insert_node(3, "'my value'"),
  text_node({ ';' }),
})
-- }}}

-- cstr {{{
local constructor_snippet = snippet({ trig = 'cstr', name = 'Constructor' }, {
  text_node({ '', '' }),
  choice_node(1, {
    text_node('public'),
    text_node('protected'),
    text_node('public'),
  }),
  text_node(' function __construct('),
  text_node({ '', '' }),
  text_node('    '),
  insert_node(2, 'MyClass'),
  text_node(' $'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 2),
  text_node({ '', ') {', '' }),
  text_node('    '),
  text_node('$this->'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 2),
  text_node(' = $'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 2),
  text_node(';'),
  text_node({ '', '}' }),
})
-- }}}

-- let {{{
local let_snippet = snippet({ trig = 'let', name = 'Phpspec Let' }, {
  text_node(''),
  text_node('public function let('),
  text_node({ '', '' }),
  text_node('    '),
  insert_node(1, 'MyClass'),
  text_node(' $'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 1),
  text_node({ '', '): void {', '' }),
  text_node('    '),
  text_node('$this->beConstructedWith('),
  text_node({ '', '        $' }),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 1),
  text_node({ '', '    );' }),
  text_node({ '', '}', '' }),
})
-- }}}

-- gtr {{{
local getter_snippet = snippet({ trig = 'gtr', name = 'Getter' }, {
  text_node({ '', '' }),
  choice_node(1, {
    text_node('public'),
    text_node('protected'),
    text_node('public'),
  }),
  text_node(' function get'),
  insert_node(2, 'MyProperty'),
  text_node('('),
  insert_node(3, 'string'),
  text_node(' $'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 2),
  text_node('): '),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 3),
  text_node({ '', '' }),
  text_node('    '),
  text_node('return $this->'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 2),
  text_node(';'),
  text_node({ '', '}' }),
})
-- }}}

-- str {{{
local setter_snippet = snippet({ trig = 'str', name = 'Setter' }, {
  text_node({ '', '' }),
  choice_node(1, {
    text_node('public'),
    text_node('protected'),
    text_node('public'),
  }),
  text_node(' function set'),
  insert_node(2, 'MyProperty'),
  text_node('('),
  insert_node(3, 'string'),
  text_node(' $'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 2),
  text_node('): void'),
  text_node({ '', '{', '' }),
  text_node('    '),
  text_node('$this->'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 2),
  text_node(' = $'),
  lambda_node(lambda_node._1:gsub('%a', string.lower, 1), 2),
  text_node(';'),
  text_node({ '', '}' }),
})
-- }}}

-- meth {{{
local method_snippet = snippet({ trig = 'meth', name = 'Method' }, {
  text_node({ '', '' }),
  choice_node(1, {
    text_node('public'),
    text_node('protected'),
    text_node('public'),
  }),
  text_node(' function '),
  insert_node(2, 'myMethod'),
  text_node('('),
  insert_node(3),
  text_node('): '),
  insert_node(4, 'void'),
  text_node({ '', '{', '' }),
  text_node('    '),
  insert_node(5),
  text_node({ '', '}' }),
})
-- }}}

return {
  class_snippet,
  artisan_snippet,
  interface_snippet,
  phpspec_class_snippet,
  phpspec_method_snippet,
  strict_types_snippet,
  inherit_doc_snippet,
  palette_log_snippet,
  legacy_log_snippet,
  zed_log_snippet,
  assign_snippet,
  argument_snippet,
  class_var_snippet,
  constant_snippet,
  constructor_snippet,
  let_snippet,
  getter_snippet,
  setter_snippet,
  method_snippet,
}
