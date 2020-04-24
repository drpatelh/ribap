/*Comment section: */

process ilp_solve {
  label 'glpk'
  publishDir "${params.output}/ilp/solved", mode: 'copy', pattern: "*sol" 
  publishDir "${params.output}/ilp/solved", mode: 'copy', pattern: "*simple" 

  input: 
    path(ilp)

  output:
    tuple file("*sol"), file("*simple")

  script:
    """
    BN=\$(basename ${ilp} .ilp)
    glpsol --lp \$BN.ilp --mipgap 0.01 --pcost --cuts --memlim 16834 --tmlim ${params.tmlim} -o \$BN.sol  
    cat \$BN.sol | awk '\$2 ~ /x_A.*_B/{print}' > \$BN.simple
    """
}
