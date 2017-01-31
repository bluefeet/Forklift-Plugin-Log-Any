requires 'Forklift'         => 0.01;
requires 'strictures'       => 2.000000;
requires 'namespace::clean' => 0.24;
requires 'Moo'              => 2.000000;
requires 'MooX::PluginKit'  => 0.03;
requires 'Log::Any'         => 1.041;

on test => sub {
   requires 'Test2::Bundle::Extended' => '0.000051';
};
