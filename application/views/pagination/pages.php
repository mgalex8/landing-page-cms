<?php
$pages_count = ceil($count_all / $perpage);
//    var_dump($pages_count);die();
?>

<div class="pagination pagination-centered">
    <ul>
        
        <?php if ( $page > 1 ) { ?>
        <li><a class="prev js-pagination" href="javascript:void(0);" data-id="prev">Previous</a></li>
        <?php } ?>
        
        <?php
        for ( $i = 1; $i <= $pages_count; $i++ ) {
            if ( abs($page - $i) < 5 ) {
                ?>
                <li class="<?php echo ($i == $page) ? 'active' : '' ?>" ><a data-id="<?php echo $i ?>"
                   href="?page=<?php echo $i ?>"><?php echo $i ?></a></li>
                   <?php
               }
           }
           ?>
           
            
        <?php if ( ($page >= 1) && ($page <= $pages_count - 1) ) { ?>
        <li><a class="next js-pagination" href="javascript:void(0);" data-id="next">Next</a></li>
        <?php } ?>
    </ul>
</div>

<script type="text/javascript">
    jQuery(document).ready(function(){
        var page = '<?php echo $page ?>';
        var base = '<?php echo URL::base() ?>';
        var perpage = '<?php echo $perpage ?>';        
<?php if ( $page > 1 ) { ?>
            jQuery('.prev').attr('href', '?page=<?php echo ($page - 1) ?>');
<?php } ?>
<?php if ( $page < $pages_count ) { ?>
            jQuery('.next').attr('href', '?page=<?php echo ($page + 1) ?>');
<?php } ?>
    });
</script>