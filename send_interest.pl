#! /usr/bin/perl

$database_path = "data.log.txt";

# $_[0]のみ削除
sub remove_line
{
  open ( FILE, "<$database_path" );
  @buff = <FILE>;
  close ( FILE );

  open ( FILE, ">$database_path" );


  foreach ( @buff )
  {
    $_ =~ s/\n//g;
    @str = split ( /\t/, $_ );

    if ( $str[0] ne $_[0] )
    {
      print FILE "$_\n";
    }
  }

  close ( FILE );
}

sub summarize_new_request
{
  open ( FILE, "<$database_path" );
  @buff = <FILE>;
  close ( FILE );

  # Aのみ抽出
  foreach ( @buff )
  {
    $_ =~ s/\n//g;
    @str = split ( /\t/, $_ );

    if ( $str[0] eq 'A' )
    {
      push ( @addr, $str[1] );
    }
  }

  # AをまとめてNにする
  $count{$_}++ for ( @addr );
  &remove_line('A');
  open ( FILE, ">>$database_path" );
  foreach my $key ( keys (%count ) )
  {
    $val = $count{$key};
    print FILE "N\t$key\t$val\n";
  }
  close ( FILE );

}

sub send_interst
{
  open ( FILE, "<$database_path" );
  @buff = <FILE>;
  close ( FILE );

  open ( FILE, ">>$database_path" );
  # Nのみ抽出
  foreach ( @buff )
  {
    $_ =~ s/\n//g;
    @str = split ( /\t/, $_ );

    if ( $str[0] eq 'N' )
    {
      push ( @list, $str[1] );
      print FILE "R\t$str[1]\t$str[2]\n";
    }
  }
  close(FILE);

  &remove_line('N');

  #
  foreach ( @list )
  {
    @path = split('/', $_ );
    `cefgetfile $_.jpg -f ./$path[2]_$path[3].jpg`;
  }
}

&summarize_new_request();
&send_interst();
