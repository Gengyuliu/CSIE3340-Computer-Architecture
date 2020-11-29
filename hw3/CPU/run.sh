for i in `seq 0 7`; do
    iverilog -D T$i -f ./cpu.f
    vvp ./a.out
    echo ">>>>>>>>>>>>>>>>>"
    rm ./a.out
done
